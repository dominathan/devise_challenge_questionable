module DeviseChallengeQuestionable
  module Generators
    class DeviseChallengeQuestionableGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)
      namespace "devise_challenge_questionable"

      desc "Adds :challenge_questionable directive in the given model. It also generates an active record migration."

      def inject_devise_challenge_questionable_content
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, "challenge_questionable, :", :after => "devise :") if File.exists?(path)
        inject_into_file(path, "user_challenge_questions_attributes, :", :after => "attr_accessible :") if File.exists?(path)
        inject_into_file path, :after => "class #{class_name} < ActiveRecord::Base\n" do
<<-CONTENT
  has_many :#{class_name.underscore}_challenge_questions, :validate => true, :inverse_of => :user
  accepts_nested_attributes_for :#{class_name.underscore}_challenge_questions, :allow_destroy => true
CONTENT
        end if File.exists?(path)
      end
      
      def generate_model
        invoke "active_record:model", ["#{file_path}_challenge_question"], :migration => false
      end
      
      def inject_scope_challenge_question_content
        path = File.join("app", "models", "#{file_path}_challenge_question.rb")
        inject_into_file path, :before => /^end/ do
<<-CONTENT
  belongs_to :#{class_name.underscore}

  validates :challenge_question, :challenge_answer, :presence => true
  validates :challenge_answer, :length => { :in => 3..56 }, :format => {:with => /^[\\w\\s:]*$/, :message => "can not contain special characters"}, :allow_blank => true

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
    if self.challenge_question.present? && self.#{class_name.underscore}.#{class_name.underscore}_challenge_questions.select{|q| q.challenge_question == self.challenge_question}.count > 1
      errors.add(:challenge_question, 'can only be used once')
    end
  end

  def challenge_answer_uniqueness
    if  self.challenge_answer.present? && self.#{class_name.underscore}.#{class_name.underscore}_challenge_questions.select{|q| q.challenge_answer == self.challenge_answer}.count > 1
      errors.add(:challenge_answer, 'can only be used once')
    end
  end
  
  def challenge_answer_repeating
    if self.challenge_answer.present? && self.challenge_answer =~ /(.)\1{2,}/
      errors.add(:challenge_answer, 'can not have more then two repeating characters in a row')
    end
  end
CONTENT
        end if File.exists?(path)
      end
      
      def inject_localization_model_content
        path = File.join("config", "locales", "devise.en.yml")
        inject_into_file path, :after => "en:\n" do
<<-CONTENT
  activerecord:
    attributes:
      #{class_name.underscore}:
        #{class_name.underscore}_challenge_questions:
          challenge_question: "Question"
          challenge_answer: "Answer"
CONTENT
        end if File.exists?(path)
        inject_into_file path, :after => "devise:\n" do
<<-CONTENT
    challenge_questions:
      attempt_failed: "Attempt failed."
      updated_challenge_questions: "Successfully updated challenge questions."
      send_instructions: "You will receive an email with instructions about how to reset your challenge questions in a few minutes."
CONTENT
        end if File.exists?(path)
      end
      
      hook_for :orm

    end
  end
end


