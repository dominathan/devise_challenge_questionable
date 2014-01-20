module DeviseChallengeQuestionable
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_filter :handle_challenge_questions
      end

      private

      def handle_challenge_questions
        unless devise_controller?
          Devise.mappings.keys.flatten.any? do |scope|
            if signed_in?(scope) and warden.session(scope)[:need_challenge_questions]
              failed_challenge_question(scope)
            end
          end
        end
      end

      def failed_challenge_question(scope)
        if request.format.present? and request.format.html?
          session["#{scope}_return_tor"] = request.path if request.get?
          redirect_to challenge_questions_path_for(scope)
        else
          render :nothing => true, :status => :unauthorized
        end
      end

      def challenge_questions_path_for(resource_or_scope = nil)
        scope = Devise::Mapping.find_scope!(resource_or_scope)
        change_path = "#{scope}_challenge_question_path"
        send(change_path)
      end

    end
  end
end