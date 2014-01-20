class Devise::ChallengeQuestionsController < ApplicationController
  include Devise::Controllers::InternalHelpers
  prepend_before_filter :authenticate_scope!
  before_filter :prepare_and_validate, :handle_challenge_questions
  layout 'devise'

  def show
    @challenge_question = resource.send("#{resource_name}_challenge_questions").sample
    render_with_scope :show
  end

  def update
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
      set_flash_message :error, :attempt_failed
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
