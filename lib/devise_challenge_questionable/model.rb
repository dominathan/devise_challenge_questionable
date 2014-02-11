require 'devise_challenge_questionable/hooks/challenge_questions'
module Devise
  module Models
    module ChallengeQuestionable
      extend ActiveSupport::Concern
      
      # Update challenge questions saving the record and clearing token. Returns true if
      # the challenge questions are valid and the record was saved, false otherwise.
      def reset_challenge_questions!(attributes)
        self.send("#{self.class.name.underscore}_challenge_questions").destroy_all
        self.attributes = {"#{self.class.name.underscore}_challenge_questions_attributes" => attributes["#{self.class.name.underscore}_challenge_questions_attributes"]}       
        clear_reset_challenge_questions_token if self.valid?
        self.save
      end

      def login_challenge_questions?(request)
        true
      end
      
      def set_challenge_questions?(request)
        true
      end
      
      def max_challenge_question_lock_account
        self.lock_access! if self.class.lock_strategy_enabled?(:failed_attempts)
      end

      def max_challenge_question_attempts?
        challenge_question_failed_attempts >= self.class.max_challenge_question_attempts
      end
      
      # Resets reset challenge question token and send reset challenge question instructions by email
      def send_reset_challenge_questions_instructions
        generate_reset_challenge_questions_token!
        ::Devise.mailer.reset_challenge_questions_instructions(self).deliver
      end
      
      # Generates a new random token for reset challenge_question
      def set_reset_challenge_questions_token
        generate_reset_challenge_questions_token!
      end
      
      def unlock_access_including_challenge_questions!
        if_access_locked do
          self.locked_at = nil
          self.failed_attempts = 0 if respond_to?(:failed_attempts=)
          self.challenge_question_failed_attempts = 0 if respond_to?(:challenge_question_failed_attempts=)
          self.unlock_token = nil  if respond_to?(:unlock_token=)
          save(:validate => false)
        end
      end
      
      protected

        # Generates a new random token for reset challenge_question
        def generate_reset_challenge_questions_token
          self.reset_challenge_questions_token = self.class.reset_challenge_questions_token
        end

        # Resets the reset challenge_question token with and save the record without
        # validating
        def generate_reset_challenge_questions_token!
          generate_reset_challenge_questions_token && save(:validate => false)
        end

        # Removes reset_challenge_question token
        def clear_reset_challenge_questions_token
          self.reset_challenge_questions_token = nil
        end
        
        def clear_challenge_question_failed_attempts
          self.challenge_question_failed_attempts = 0
        end
        
      module ClassMethods
        ::Devise::Models.config(self, :max_challenge_question_attempts)
        
        # Attempt to find a user by it's email. If a record is found, send new
        # challenge_question instructions to it. If not user is found, returns a new user
        # with an email not found error.
        # Attributes must contain the user email
        def send_reset_challenge_questions_instructions(attributes={})
          challenge_questionable = find_or_initialize_with_error_by(:email, attributes[:email], :not_found)
          challenge_questionable.send_reset_challenge_questions_instructions if challenge_questionable.persisted?
          challenge_questionable
        end

        # Generate a token checking if one does not already exist in the database.
        def reset_challenge_questions_token
          generate_token(:reset_challenge_questions_token)
        end

        # Attempt to find a user by it's reset_challenge_questions_token to reset it's
        # challenge_question. If a user is found, reset it's challenge_question and automatically
        # try saving the record. If not user is found, returns a new user
        # containing an error in reset_challenge_questions_token attribute.
        # Attributes must contain reset_challenge_questions_token, challenge_question and confirmation
        def reset_challenge_questions_by_token(attributes={})
          challenge_questionable = find_or_initialize_with_error_by(:reset_challenge_questions_token, attributes[:reset_challenge_questions_token])
          challenge_questionable.reset_challenge_questions!(attributes) if challenge_questionable.persisted?
          challenge_questionable
        end
      end
    end
  end
end