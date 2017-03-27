## Challenge questions plugin for Devise

This plugin forces a two step login process.  After entering username/email and password, you must then answer a challenge question.  Unlike security questions which are typically used when doing things like changing passwords, the challenge question must be answered each time logging in.  You can set which users or admins need to answer a challenge question.  We will assume your resource is User for the remainder of the Readme.
## Features

* configure max challenge question attempts
* configure number of challenge questions stored for each user
* configure number of challenge questions asked for each user
* per user level control if he really need challenge question authentication

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

    bundle exec rails g devise_challenge_questionable:views users

Where MODEL is your model name (e.g. User or Admin). This generator will add `:challenge_questionable` to your model
and create a migration in `db/migrate/`, which will add `:reset_challenge_questions_token` and `:challenge_question_failed_attempts` to your table.
Finally, run the migration with:

    bundle exec rake db:migrate


### Manual installation

To manually enable challenge questions for the User model, you should add the following. Set up relationships. You should already have a devise line so you would just add :challenge_questionable to it.  Also, you need to allow accessibility to `:user_challenge_questions_attributes`.  Replace user with whatever resource you are using. Typically it would be user or admin.

```ruby
  has_many :user_challenge_questions, :validate => true, :inverse_of => :user
  accepts_nested_attributes_for :user_challenge_questions, :allow_destroy => true

  devise :challenge_questionable

  attr_accessible :user_challenge_questions_attributes
```

You also need to add the `user_challenge_question.rb` Model.

```ruby
  class UserChallengeQuestion < ActiveRecord::Base
    belongs_to :user

    validates :challenge_question, :challenge_answer, :presence => true
    validates :challenge_answer, :length => { :in => 4..56 }, :format => {:with => /^[\w\s:]*$/, :message => "can not contain special characters"}, :allow_blank => true

    # Must use custom validation since uniqueness scope will not work with has_many association
    validate :challenge_question_uniqueness
    validate :challenge_answer_uniqueness
    validate :challenge_answer_repeating

    before_save :digest_challenge_answer

    def digest_challenge_answer
      if ENV['PASSWORD_PEPPER']
        write_attribute(:challenge_answer, ::BCrypt::Password.create(self.challenge_answer.downcase + ENV['PASSWORD_PEPPER'], :cost => Devise.stretches)) unless self.challenge_answer.nil?
      else
        write_attribute(:challenge_answer, ::BCrypt::Password.create(self.challenge_answer.downcase, :cost => Devise.stretches)) unless self.challenge_answer.nil?
      end
    end

    private
    def challenge_question_uniqueness
      if self.challenge_question.present? && self.user.user_challenge_questions.select{|q| q.challenge_question == self.challenge_question}.count > 1
        errors.add(:challenge_question, 'can only be used once')
      end
    end

    def challenge_answer_uniqueness
      if  self.challenge_answer.present? && self.user.user_challenge_questions.select{|q| q.challenge_answer == self.challenge_answer}.count > 1
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

  # Number of challenge questions to store for each user
  config.number_of_challenge_questions = 3

  # Default challenge question options
  config.challenge_questions = ["What was your high school mascot?","In which city was your first elementary school?","In which city was your mother born?","What is the name of your favorite movie?","Who is your favorite athlete?","What was your most memorable gift as a child?","What is your favorite cartoon character?","What is the name of your favorite novel?","Name of favorite childhood pet?","What is the name of your elementary school?","What is your youngest child's middle name?","Last Name of your kindergarten teacher?","What is the first name of your grandmother (your father's mother)?","What is your spouse's nickname?","Name of the place where your wedding reception was held?","Name of a college you applied to but did not attend?","What is the first name of the youngest of your siblings?","What is the first name of the eldest of your siblings?","What is your favorite television show?","If you needed a new first name, what would it be?","What is the first name of your youngest child?","When is your mother's birthday (MM/DD)?","What is your eldest child's middle name?","What is the last name of the funniest friend you know?","Name the highest mountain you've been to the top of?","What is the first name of your grandmother (your mother's mother)?","What is the first name of your grandfather (your mother's father)?","What was the first name of your best man/maid of honor?","What was the last name of your first grade teacher?","What is the last name of your first boyfriend or girlfriend?","Which high school did you attend?","What was your major during college?","What was the name of your first pet?","What was your favorite place from your childhood?","What is your favorite song?","What is your favorite car?","What is your mother’s middle name?","What is the (MM/DD) of your employment?","What is the make/model of first car?","What is the name of the city or town where you were born?","What is the name of your favorite childhood teacher?","What is the name of your favorite childhood friend?","What are your oldest sibling’s (MM/YYYY) of birth?","What is your oldest sibling’s middle name?","What school did you attend for sixth grade?","On what street did you live in third grade?"]

```

### Customization

By default challenge questions are enabled for each user, you can change it with this method in your User model:

```ruby
  def login_challenge_questions?(request)
    request.ip != '127.0.0.1'
  end

  def set_challenge_questions?(request)
    request.ip != '127.0.0.1'
  end
```

this will disable challenge questions for local users
