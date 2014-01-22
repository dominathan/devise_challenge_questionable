## Challenge questions plugin for Devise

This plugin forces a two step login process.  After entering username and password, you must then answer a challenge question.  Unlike security questions which are typically used when doing things like changing passwords, the challenge question must be answered each time logging in.  You can set which users need to answer a challenge question
## Features

* configure max challenge question attempts
* configure number of challenge questions stored for each user
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

To manually enable challenge questions for the User model, you should add challenge_questionable to your devise line, like:

```ruby
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :challenge_questionable
```

Two default parameters

```ruby
  # ==> Configuration for :challenge_questionable
  # Max challenge question attempts
  config.max_challenge_question_attempts = 3

  # Number of challenge questions to store for each user
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

By default challenge questions are enabled for each user, you can change it with this method in your User model:

```ruby
  def need_challenge_questions?(request)
    request.ip != '127.0.0.1'
  end
```

this will disable challenge questions for local users
