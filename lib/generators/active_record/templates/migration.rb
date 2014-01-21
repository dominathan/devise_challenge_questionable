class DeviseChallengeQuestionableAddTo<%= table_name.camelize %> < ActiveRecord::Migration  
  def self.up
    add_column :<%= table_name %>, :reset_challenge_questions_token, :string
    add_column :<%= table_name %>, :challenge_question_failed_attempts, :integer, :default => 0
    
    create_table :<%= class_name.underscore %>_challenge_questions do |t|
      t.integer :<%= table_name.singularize %>_id
      t.string  :challenge_question
      t.string  :challenge_answer
      t.timestamps
    end
    
  end

  def self.down
    drop_table :<%= class_name.underscore %>_challenge_questions
    remove_column :<%= table_name %>, :reset_challenge_questions_token
    remove_column :<%= table_name %>, :challenge_question_failed_attempts
  end

end
