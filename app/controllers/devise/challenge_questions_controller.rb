class Devise::ChallengeQuestionsController < ApplicationController
  include Devise::Controllers::InternalHelpers
  prepend_before_filter :require_no_authentication, :only => [:new, :create, :edit, :update]
  prepend_before_filter :authenticate_scope!, :only => [:show, :authenticate]
  before_filter :prepare_and_validate, :handle_challenge_questions, :only => [:show, :authenticate] 
  layout 'devise'
  
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
    3.times { resource.send("#{resource_name}_challenge_questions").build }
    render_with_scope :edit
  end
  
  # PUT /resource/challenge_question
  def update
    self.resource = resource_class.reset_challenge_questions_by_token(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :updated
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :edit
    end
  end

  # GET /resource/challenge_question
  def show
    @challenge_question = resource.send("#{resource_name}_challenge_questions").sample
    render_with_scope :show
  end

  def authenticate
    render_with_scope :show and return if params[:answer].nil?
    @challenge_question = resource.send("#{resource_name}_challenge_questions").find(params[:challenge_question_id])
    md5 = Digest::MD5.hexdigest(params[:answer])
    if md5.eql?(@challenge_question.answer)
      warden.session(resource_name)[:need_challenge_questions] = false
      sign_in resource_name, resource#, :bypass => true
      redirect_to stored_location_for(resource_name) || :root
      resource.update_attribute(:challenge_question_failed_attempts, 0)
    else
      resource.challenge_question_failed_attempts += 1
      resource.save
      set_flash_message :notice, :attempt_failed
      if resource.max_challenge_question_attempts?
        sign_out(resource)
        render_with_scope :max_challenge_question_attempts_reached and return
      else
        render_with_scope :show
      end
    end
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
