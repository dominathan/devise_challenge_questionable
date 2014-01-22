require 'devise_challenge_questionable/version'
require 'devise'
require 'digest'
require 'active_support/concern'

module Devise
  mattr_accessor :max_challenge_question_attempts
  @@max_challenge_question_attempts = 3
  
  mattr_accessor :challenge_questions 
  @@challenge_questions = ["What was your high school mascot?","In which city was your first elementary school?","In which city was your mother born?","What is the name of your favorite movie?","Who is your favorite athlete?","What was your most memorable gift as a child?","What is your favorite cartoon character?","What is the name of your favorite novel?","Name of favorite childhood pet?","What is the name of your elementary school?","What is your youngest child's middle name?","Last Name of your kindergarten teacher?","What is the first name of your grandmother (your father's mother)?","What is your spouse's nickname?","Name of the place where your wedding reception was held?","Name of a college you applied to but did not attend?","What is the first name of the youngest of your siblings?","What is the first name of the eldest of your siblings?","What is your favorite television show?","If you needed a new first name, what would it be?","What is the first name of your youngest child?","When is your mother's birthday (MM/DD)?","What is your eldest child's middle name?","What is the last name of the funniest friend you know?","Name the highest mountain you've been to the top of?","What is the first name of your grandmother (your mother's mother)?","What is the first name of your grandfather (your mother's father)?","What was the first name of your best man/maid of honor?","What was the last name of your first grade teacher?","What is the last name of your first boyfriend or girlfriend?","Which high school did you attend?","What was your major during college?","What was the name of your first pet?","What was your favorite place from your childhood?","What is your favorite song?","What is your favorite car?","What is your mother’s middle name?","What is the (MM/DD) of your employment?","What is the make/model of first car?","What is the name of the city or town where you were born?","What is the name of your favorite childhood teacher?","What is the name of your favorite childhood friend?","What are your oldest sibling’s (MM/YYYY) of birth?","What is your oldest sibling’s middle name?","What school did you attend for sixth grade?","On what street did you live in third grade?"]

  
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

