FactoryGirl.define do
  factory :answer do
    question
    evaluation
    numeric_response {rand(1..10)}
  end

  factory :text_answer, class: Answer do
    association :question, factory: :text_question
    evaluation
  end
end
