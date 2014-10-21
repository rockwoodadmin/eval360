class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :evaluation

  validates_presence_of :question
  validates_presence_of :evaluation
end
