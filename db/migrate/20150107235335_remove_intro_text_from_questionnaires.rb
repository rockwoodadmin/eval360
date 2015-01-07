class RemoveIntroTextFromQuestionnaires < ActiveRecord::Migration
  def change
    remove_column :questionnaires, :self_intro_text, :string
    remove_column :questionnaires, :intro_text, :string
  end
end
