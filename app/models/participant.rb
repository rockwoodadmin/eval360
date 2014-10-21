class Participant < ActiveRecord::Base
  acts_as :evaluator
  has_many :evaluations
  belongs_to :training, inverse_of: :participants
  validates_presence_of :training

  def self_evaluation
    evaluations.where(participant_id: self.id).first
  end

  def program
    self.training.program
  end

end
