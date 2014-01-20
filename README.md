## Challenge questions plugin for Devise

## Features

* configure max challenge question attempts
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
  config.devise.max_challenge_question_attempts = 3
```

### Customization

By default challenge questions are enabled for each user, you can change it with this method in your User model:

```ruby
  def need_challenge_questions?(request)
    request.ip != '127.0.0.1'
  end
```

this will disable challenge questions for local users
