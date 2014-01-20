module DeviseChallengeQuestionable
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Add DeviseChallengeQuestionable config variables to the Devise initializer and copy DeviseChallengeQuestionable locale files to your application."
      
      def add_config_options_to_initializer
        devise_initializer_path = "config/initializers/devise.rb"
        if File.exist?(devise_initializer_path)
          old_content = File.read(devise_initializer_path)
          
          if old_content.match(Regexp.new(/^\s# ==> Configuration for :challenge_questionable\n/))
            false
          else
            inject_into_file(devise_initializer_path, :before => "  # ==> Configuration for :confirmable\n") do
<<-CONTENT
  # ==> Configuration for :challenge_questionable
  # Max challenge question attempts
  config.max_challenge_question_attempts = 3
  
  # Default challenge question options
  config.challenge_questions = ["What is your mother’s middle name?",
  "What are the month / day of your employment?", "What is the make/model of first car?", 
  "What is the name of the city or town where you were born?", "What is the name of your favorite childhood teacher?", 
  "What is the name of your first pet?", "What is the name of your favorite childhood friend?", 
  "What are your oldest sibling’s month and year of birth?", "What is your oldest sibling’s middle name?", 
  "What school did you attend for sixth grade?", "On what street did you live in third grade?", 
  "What was your high school mascot?"]
  
CONTENT
            end
          end
        end
      end
      
      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/devise_challenge_questionable.en.yml"
      end
      
    end
  end
end