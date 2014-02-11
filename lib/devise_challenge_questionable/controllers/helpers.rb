module DeviseChallengeQuestionable
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter :handle_challenge_questions
      end

      private

      def handle_challenge_questions
        unless devise_controller? && (controller_name != 'registrations' && ![:edit, :update, :destroy].include?(action_name))
          Devise.mappings.keys.flatten.any? do |scope|
            if signed_in?(scope)
              set_challenge_questions(scope) and return if warden.session(scope)[:set_challenge_questions]
              failed_challenge_question(scope) and return if warden.session(scope)[:login_challenge_questions]
            end
          end
        end
      end
      
      def set_challenge_questions(scope)
        if request.format.present? and request.format.html?
          redirect_to set_challenge_questions_path_for(scope)
        else
          render :nothing => true, :status => :unauthorized
        end        
      end

      def failed_challenge_question(scope)
        if request.format.present? and request.format.html?
          session["#{scope}_return_to"] = request.path if request.get?
          redirect_to challenge_questions_path_for(scope)
        else
          render :nothing => true, :status => :unauthorized
        end
      end
      
      def set_challenge_questions_path_for(resource_or_scope = nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        change_path = "manage_#{scope}_challenge_question_path"
        send(change_path)        
      end

      def challenge_questions_path_for(resource_or_scope = nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        change_path = "#{scope}_challenge_question_path"
        send(change_path)
      end

    end
  end
end