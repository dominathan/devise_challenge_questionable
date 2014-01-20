class <%= class_name %>ChallengeQuestion < ActiveRecord::Base
  
  belongs_to :<%= class_name.underscore %>
  
end