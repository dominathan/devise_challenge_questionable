require 'devise_challenge_questionable/hooks/challenge_questions'
module Devise
  module Models
    module ChallengeQuestionable
      extend ActiveSupport::Concern

      module ClassMethods
        ::Devise::Models.config(self, :max_challenge_question_attempts)
      end

      def need_challenge_questions?(request)
        true
      end

      def max_challenge_question_attempts?
        challenge_question_failed_attempts >= self.class.max_challenge_question_attempts
      end
    end
  end
end