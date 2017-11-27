require 'rails_helper'

RSpec.feature 'Sends Assessment Done Email', type: :feature do
  let(:evaluation) { FactoryGirl.create(:self_evaluation_with_answers) }
  let(:email_address) { "email#{rand(100)}@example.com" }

  scenario 'participant completes self assessment with 1 invite' do
    visit edit_evaluation_path(evaluation)
    click_on 'Submit'
    within(:css, "#participant_evaluators_attributes_3_email_input") do
      fill_in 'Email', with: email_address
    end
    click_on "Invite Peers"

    open_email(email_address)
    expect(current_email.subject).to eq "Assessment Done"
  end
end
