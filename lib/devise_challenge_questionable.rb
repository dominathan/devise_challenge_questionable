require 'devise_challenge_questionable/version'
require 'devise'
require 'digest'
require 'active_support/concern'

module Devise
  mattr_accessor :max_challenge_question_attempts
  @@max_challenge_question_attempts = 3
  
  mattr_accessor :challenge_questions 
  @@challenge_questions = ["What is your mother’s middle name?",
  "What are the month / day of your employment?", "What is the make/model of first car?", 
  "What is the name of the city or town where you were born?", "What is the name of your favorite childhood teacher?", 
  "What is the name of your first pet?", "What is the name of your favorite childhood friend?", 
  "What are your oldest sibling’s month and year of birth?", "What is your oldest sibling’s middle name?", 
  "What school did you attend for sixth grade?", "On what street did you live in third grade?", 
  "What was your high school mascot?"]
  
  mattr_accessor :number_of_challenge_questions
  @@number_of_challenge_questions = 3
end

module DeviseChallengeQuestionable
  autoload :Schema, 'devise_challenge_questionable/schema'
  module Controllers
    autoload :Helpers, 'devise_challenge_questionable/controllers/helpers'
    autoload :UrlHelpers, 'devise_challenge_questionable/controllers/url_helpers'
  end
end

Devise.add_module :challenge_questionable, :model => 'devise_challenge_questionable/model', :controller => :challenge_questions, :route => :challenge_question

require 'devise_challenge_questionable/mailer'
require 'devise_challenge_questionable/routes'
require 'devise_challenge_questionable/model'
require 'devise_challenge_questionable/rails'

