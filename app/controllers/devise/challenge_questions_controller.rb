class Devise::ChallengeQuestionsController < ApplicationController
  include Devise::Controllers::InternalHelpers
  prepend_before_filter :authenticate_scope!, :only => [:show, :authenticate, :manage]
  before_filter :prepare_and_validate, :handle_challenge_questions, :only => [:show, :authenticate] 
  
  # GET /resource/challenge_question/new
  def new
    build_resource
    render_with_scope :new
  end
  
  # POST /resource/challenge_question
  def create
    self.resource = resource_class.send_reset_challenge_questions_instructions(params[resource_name])
    
    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
      sign_out(resource)
      redirect_to new_session_path(resource_name)
    else
      render_with_scope :new
    end
  end
  
  # GET /resource/challenge_question/edit?reset_challenge_questions_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_challenge_questions_token = params[:reset_challenge_questions_token]
    Devise.number_of_challenge_questions.times { resource.send("#{resource_name}_challenge_questions").build }
    render_with_scope :edit
  end
  
  # PUT /resource/challenge_question
  def update
    self.resource = resource_class.reset_challenge_questions_by_token(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :updated_challenge_questions
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :edit
    end
  end

  # GET /resource/challenge_question
  def show
    @challenge_question = resource.send("#{resource_name}_challenge_questions").sample
    if @challenge_question.nil?
      resource.set_reset_challenge_questions_token
      redirect_to edit_challenge_question_path(resource, :reset_challenge_questions_token => resource.reset_challenge_questions_token) 
    else
      render_with_scope :show
    end
  end

  def authenticate
    render_with_scope :show and return if params[:challenge_answer].nil?
    @challenge_question = resource.send("#{resource_name}_challenge_questions").find(params[:challenge_question_id])
    md5 = Digest::MD5.hexdigest(params[:challenge_answer].downcase)
    if md5.eql?(@challenge_question.challenge_answer)
      warden.session(resource_name)[:need_challenge_questions] = false
      sign_in resource_name, resource
      redirect_to stored_location_for(resource_name) || :root
      resource.update_attribute(:challenge_question_failed_attempts, 0)
    else
      resource.challenge_question_failed_attempts += 1
      resource.save
      set_flash_message :notice, :attempt_failed
      if resource.max_challenge_question_attempts?
        resource.max_challenge_question_lock_account
        sign_out(resource)
        render_with_scope :max_challenge_question_attempts_reached and return
      else
        redirect_to send("#{resource_name}_challenge_question_path")
      end
    end
  end
  
  # Build token and redirect
  def manage
    resource.set_reset_challenge_questions_token
    redirect_to edit_challenge_question_path(resource, :reset_challenge_questions_token => resource.reset_challenge_questions_token) 
  end

  private

    def authenticate_scope!
      self.resource = send("current_#{resource_name}")
    end

    def prepare_and_validate
      redirect_to :root and return if resource.nil?
      @limit = resource.class.max_challenge_question_attempts
      if resource.max_challenge_question_attempts?
        sign_out(resource)
        render_with_scope :max_challenge_question_attempts_reached and return
      end
    end
end
