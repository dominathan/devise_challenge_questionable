module DeviseChallengeQuestionable
  module Generators
    class DeviseChallengeQuestionableGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      namespace "devise_challenge_questionable"

      desc "Adds :challenge_questionable directive in the given model. It also generates an active record migration."

      def inject_devise_challenge_questionable_content
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, "challenge_questionable, :", :after => "devise :") if File.exists?(path)
        inject_into_file(path, "  has_many :#{class_name.underscore}_challenge_questions, :validate => true\n", :after => "class #{class_name} < ActiveRecord::Base\n") if File.exists?(path)
        inject_into_file(path, "  accepts_nested_attributes_for :#{class_name.underscore}_challenge_questions, :allow_destroy => true\n\n", :after => "has_many :#{class_name.underscore}_challenge_questions, :validate => true\n") if File.exists?(path)
        inject_into_file(path, "user_challenge_questions_attributes, :", :after => "attr_accessible :") if File.exists?(path)
      end
      
      def generate_model
        invoke "active_record:model", ["#{file_path}_challenge_question"], :migration => false
      end
      
      def inject_scope_challenge_question_content
        path = File.join("app", "models", "#{file_path}_challenge_question.rb")
        inject_into_file path, :before => /^end/ do <<-"""
  belongs_to :#{class_name.underscore}

  validates :challenge_question, :uniqueness => {:scope => :#{class_name.underscore}_id}
  validates :challenge_answer, :presence => true

  before_save :digest_challenge_answer

  def digest_challenge_answer
    write_attribute(:challenge_answer, Digest::MD5.hexdigest(self.challenge_answer)) unless self.challenge_answer.nil?
  end
"""
        end if File.exists?(path)
      end

      hook_for :orm

    end
  end
end
