 require 'rails_helper'

 RSpec.describe Report, :type => :model do

   let(:participant) { FactoryGirl.create(:participant_with_self_and_peer_eval) }
   subject { Report.new(participant) }

   expect_it { to delegate_method(:full_name).to(:participant).with_prefix(true) }
   expect_it { to delegate_method(:self_score_for_q).to(:results) }

   describe '#training_name' do
    it 'returns the participant training name' do
     expect(subject.training_name).to eq participant.training.name
    end
   end

  describe '#sections' do
    it 'returns all the sections of the evaluation' do
      questionnaire = FactoryGirl.create(:questionnaire)
      training = FactoryGirl.create(:training, questionnaire: questionnaire)
      participant = FactoryGirl.create(:participant_with_self_and_peer_eval, training: training)
      report = Report.new(participant)
      expect(report.sections).to eq questionnaire.sections
    end
  end

  context 'evaluations results' do
    let(:participant) { FactoryGirl.create(:participant) }
    let(:evaluation_1) { FactoryGirl.create(:evaluation, participant: participant, completed: true) }
    let(:evaluation_2) { FactoryGirl.create(:evaluation, participant: participant, completed: true) }
    let(:numeric_answer_1) { rand(1..5) }
    let(:numeric_answer_2) { rand(6..10) }
    let(:answer_1) { FactoryGirl.create(:answer, evaluation: evaluation_1, numeric_response: numeric_answer_1) }
    let(:question) { answer_1.question }
    let!(:answer_2) { FactoryGirl.create(:answer, evaluation: evaluation_2, numeric_response: numeric_answer_2, question: question) }


    describe '#histogram' do
      it 'returns the histogram of results for a given question' do
        histogram = subject.histogram(question.id)
        expect(histogram[numeric_answer_1]).to eq 1
        expect(histogram[numeric_answer_2]).to eq 1
      end
    end

    describe '#mean_score_for_q' do
      it 'returns the average score for the given question' do
        avg = (numeric_answer_1 + numeric_answer_2).to_f/2
        expect(subject.mean_score_for_q(question.id)).to eq avg
      end
    end

  end
 end
