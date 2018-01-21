class Report
  attr_reader :participant
  attr_reader :results
  delegate :full_name, to: :participant, prefix: true
  delegate :self_score_for_q, to: :results

  def initialize(participant)
    @participant = participant
    @results = EvaluationResults.new(participant)
  end

  def histogram(question_id)
    results.histogram_for_q(answers(question_id))
  end

  def mean_score_for_q(question_id)
    sprintf("%0.1f", results.mean_score_for_q(answers(question_id)))
  end

  def rw_quartile(question_id)
    avg = mean_score_for_q(question_id)
    results.rw_quartile(question_id, avg)
  end

  def training_name
    participant.training.name
  end

  def sections
    evaluation_id = participant.self_evaluation.id
    Section.joins("INNER JOIN questions ON questions.section_id = sections.id").
      merge( Question.joins("INNER JOIN answers ON questions.id = answers.question_id WHERE answers.evaluation_id = #{evaluation_id}") ).
      uniq
  end

  private

  def answers(question_id)
    @results.numeric_answers_for_q(question_id)
  end
end
