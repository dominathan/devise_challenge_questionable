## Challenge questions plugin for Devise

This plugin forces a two step login process.  After entering username and password, you must then answer a challenge question.  Unlike security questions which are typically used when doing things like changing passwords, the challenge question must be answered each time logging in.  You can set which users(or preferred resource) need to answer a challenge question
## Features

* configure max challenge question attempts
* configure number of challenge questions stored for each {resource}
* per {resource} level control if he really need challenge question authentication

## Configuration

### Initial Setup

In a Rails environment, require the gem in your Gemfile:

    gem 'devise_challenge_questionable'

Once that's done, run:

    bundle install


### Automatic installation

In order to add challenge questions to a model, run the command:

    bundle exec rails g devise_challenge_questionable MODEL
    
    bundle exec rails g devise_challenge_questionable:install
    
    bundle exec rails g devise_challenge_questionable:views {resource}s

Where MODEL is your model name (e.g. User or Admin). This generator will add `:challenge_questionable` to your model
and create a migration in `db/migrate/`, which will add `:reset_challenge_questions_token` and `:challenge_question_failed_attempts` to your table.
Finally, run the migration with:

    bundle exec rake db:migrate


### Manual installation

To manually enable challenge questions for the {Resource} model, you should add the following. Set up relationships. You should already have a devise line so you would just add :challenge_questionable to it.  Also, you need to allow accessibility to `:{resource}_challenge_questions_attributes`.  Replace {resource} with whatever resource you are using. Typically it would be {resource} or admin.

```ruby
  has_many :{resource}_challenge_questions, :validate => true, :inverse_of => :{resource}
  accepts_nested_attributes_for :{resource}_challenge_questions, :allow_destroy => true
  
  devise :challenge_questionable
  
  attr_accessible :{resource}_challenge_questions_attributes
```

You also need to add the `{resource}_challenge_question.rb` Model.

```ruby
  class {Resource}ChallengeQuestion < ActiveRecord::Base
    belongs_to :{resource}

    validates :challenge_question, :challenge_answer, :presence => true
    validates :challenge_answer, :length => { :in => 4..56 }, :format => {:with => /^[\w\s:]*$/, :message => "can not contain special characters"}, :allow_blank => true

    # Must use custom validation since uniqueness scope will not work with has_many association
    validate :challenge_question_uniqueness
    validate :challenge_answer_uniqueness
    validate :challenge_answer_repeating

    before_save :digest_challenge_answer

    def digest_challenge_answer
      write_attribute(:challenge_answer, Digest::MD5.hexdigest(self.challenge_answer.downcase)) unless self.challenge_answer.nil?
    end
  
    private
    def challenge_question_uniqueness
      if self.challenge_question.present? && self.{resource}.{resource}_challenge_questions.select{|q| q.challenge_question == self.challenge_question}.count > 1
        errors.add(:challenge_question, 'can only be used once')
      end
    end

    def challenge_answer_uniqueness
      if  self.challenge_answer.present? && self.{resource}.{resource}_challenge_questions.select{|q| q.challenge_answer == self.challenge_answer}.count > 1
        errors.add(:challenge_answer, 'can only be used once')
      end
    end
  
    def challenge_answer_repeating
      if self.challenge_answer.present? && self.challenge_answer =~ /(.)\1{2,}/
        errors.add(:challenge_answer, 'can not have more then two repeating characters in a row')
      end
    end
  end
```

Locales:

```yaml
  en:
    activerecord:
      attributes:
        user:
          user_challenge_questions:
            challenge_question: "Question"
            challenge_answer: "Answer"
    devise:
      challenge_questions:
        attempt_failed: "Attempt failed."
        updated_challenge_questions: "Successfully updated challenge questions."
        send_instructions: "You will receive an email with instructions about how to reset your challenge questions in a few minutes."
```

Configuration settings

```ruby
  # ==> Configuration for :challenge_questionable
  # Max challenge question attempts
  config.max_challenge_question_attempts = 3

  # Number of challenge questions to store for each {resource}
  config.number_of_challenge_questions = 3

  # Default challenge question options
  config.challenge_questions = ["What is your mother’s middle name?",
  "What are the month / day of your employment?", "What is the make/model of first car?", 
  "What is the name of the city or town where you were born?", "What is the name of your favorite childhood teacher?", "What is the name of your first pet?", "What is the name of your favorite childhood friend?", 
  "What are your oldest sibling’s month and year of birth?", "What is your oldest sibling’s middle name?", 
  "What school did you attend for sixth grade?", "On what street did you live in third grade?", 
  "What was your high school mascot?"]
```

### Customization

By default challenge questions are enabled for each {resource}, you can change it with this method in your User model:

```ruby
  def need_challenge_questions?(request)
    request.ip != '127.0.0.1'
  end
```

this will disable challenge questions for local {resource}s
