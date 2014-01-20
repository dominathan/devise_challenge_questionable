require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseChallengeQuestionableGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def copy_migration
        migration_template "migration.rb", "db/migrate/devise_challenge_questionable_add_to_#{table_name}"
      end

    end
  end
end
