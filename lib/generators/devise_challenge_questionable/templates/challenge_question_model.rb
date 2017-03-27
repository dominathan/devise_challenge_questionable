class <%= class_name %>ChallengeQuestion < ActiveRecord::Base

  belongs_to :<%= class_name.underscore %>

  validates :challenge_question, :uniqueness => {:scope => :<%= class_name.underscore %>_id}
  validates :challenge_answer, :presence => true

  before_save :digest_challenge_answer

  def digest_challenge_answer
    if ENV['PASSWORD_PEPPER']
      write_attribute(:challenge_answer, ::BCrypt::Password.create(self.challenge_answer.downcase + ENV['PASSWORD_PEPPER'], :cost => Devise.stretches)) unless self.challenge_answer.nil?
    else
      write_attribute(:challenge_answer, ::BCrypt::Password.create(self.challenge_answer.downcase, :cost => Devise.stretches)) unless self.challenge_answer.nil?
    end
  end

end
