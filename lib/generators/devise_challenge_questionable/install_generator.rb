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
  
  # Number of challenge questions to store for each user
  config.number_of_challenge_questions_stored = 3
  
  # Number of challenge questions to ask for each user
  config.number_of_challenge_questions_asked = 1
  
  # Default challenge question options
  config.challenge_questions = ["What was your high school mascot?","In which city was your first elementary school?","In which city was your mother born?","What is the name of your favorite movie?","Who is your favorite athlete?","What was your most memorable gift as a child?","What is your favorite cartoon character?","What is the name of your favorite novel?","Name of favorite childhood pet?","What is the name of your elementary school?","What is your youngest child's middle name?","What is the last name of your kindergarten teacher?","What is the first name of your grandmother (your father's mother)?","What is your spouse's nickname?","What is the name of the place where your wedding reception was held?","What is the name of a college you applied to but did not attend?","What is the first name of the youngest of your siblings?","What is the first name of the eldest of your siblings?","What is your favorite television show?","If you needed a new first name, what would it be?","What is the first name of your youngest child?","When is your mother's birthday (MM/DD)?","What is your eldest child's middle name?","What is the last name of the funniest friend you know?","What is the name the highest mountain you've been to the top of?","What is the first name of your grandmother (your mother's mother)?","What is the first name of your grandfather (your mother's father)?","What was the first name of your best man/maid of honor?","What was the last name of your first grade teacher?","What is the last name of your first boyfriend or girlfriend?","Which high school did you attend?","What was your major during college?","What was the name of your first pet?","What was your favorite place from your childhood?","What is your favorite song?","What is your favorite car?","What is your mother’s middle name?","What is the (MM/DD) of your employment?","What is the make/model of first car?","What is the name of the city or town where you were born?","What is the name of your favorite childhood teacher?","What is the name of your favorite childhood friend?","What are your oldest sibling’s month and year  (MM/YYYY) of birth?","What is your oldest sibling’s middle name?","What school did you attend for sixth grade?","On what street did you live in third grade?","What is the name of the street where you first lived?","How many full bathrooms are in your home?","What type of home do you live in?","Where was your wedding rehearsal dinner held?","In what dormitory did you live in college?","What is the first name of your oldest cousin?","What is the last name of your high school counselor?","What is the first name of your favorite aunt?","How many nieces / nephews does / did your mother have?","How many nieces / nephews does / did your father have?","What instrument did you play in school?","What is the name of your favorite college professor?","In how many states have you lived?","How many windows does your kitchen have?","How many televisions do you have in your home?","What is the brand name of your hair dryer?","What is your favorite lipstick color?","What is the name of your favorite reality show?","Who is the designer of your wedding dress?","What is your favorite shoe style?","What is your favorite flower?","What physical attribute  do you most admire of your boyfriend / girlfriend / spouse?","What is the brand name of your vacuum?","What’s your favorite fitness class?","What is your favorite spa treatment?","What is the color of your first car?","What is your favorite dessert?","Who is your cell phone carrier?","What is the name of your favorite restaurant?"]
  
CONTENT
            end
          end
        end
      end
      
    end
  end
end