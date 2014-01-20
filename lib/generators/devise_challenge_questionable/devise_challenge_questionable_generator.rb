module DeviseChallengeQuestionable
  module Generators
    class DeviseChallengeQuestionableGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      namespace "devise_challenge_questionable"

      desc "Adds :challenge_questionable directive in the given model. It also generates an active record migration."

      def inject_devise_challenge_questionable_content
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, "challenge_questionable, :", :after => "devise :") if File.exists?(path)
        inject_into_file(path, "  has_many :#{class_name.underscore}_challenge_questions\n", :after => "class #{class_name} < ActiveRecord::Base\n") if File.exists?(path)
      end
      
      def generate_model
        invoke "active_record:model", ["#{file_path}_challenge_question"], :migration => false
      end
      
      def inject_scope_challenge_question_content
        path = File.join("app", "models", "#{file_path}_challenge_question.rb")
        inject_into_file(path, "  belongs_to :#{class_name.underscore}\n", :before => /^end/) if File.exists?(path)
      end

      hook_for :orm

    end
  end
end
