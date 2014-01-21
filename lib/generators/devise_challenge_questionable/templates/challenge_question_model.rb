class <%= class_name %>ChallengeQuestion < ActiveRecord::Base
  
  belongs_to :<%= class_name.underscore %>
  
  validates :challenge_question, :uniqueness => {:scope => :<%= class_name.underscore %>_id}
  validates :challenge_answer, :presence => true
  
  before_save :digest_challenge_answer
  
  def digest_challenge_answer
    write_attribute(:challenge_answer, Digest::MD5.hexdigest(self.challenge_answer)) unless self.challenge_answer.nil?
  end
  
end