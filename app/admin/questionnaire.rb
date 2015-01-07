ActiveAdmin.register Questionnaire, as: "Assessment" do
  permit_params :name, sections_attributes: [:id, :header, questions_attributes: [:id, :answer_type, :description, :self_description ]]  

  actions :index, :show, :edit, :update
  config.filters = false
  index do
    selectable_column
    column :name
    actions
  end

  menu priority: 5, label: "Assessments"

  form do |f|
    f.inputs do
      f.input :name
    end

    f.actions
  end


  show title: :name do |questionnaire|
    attributes_table do
      row :name
    end

    questionnaire.sections.each do |section|
      
      panel section.header do
        div do
          link_to("Edit header", edit_admin_questionnaire_section_path(questionnaire, section))
        end
        table_for section.questions do
          column "Question Text" do |question|
            question.description
          end 
          column "Question Type" do |question|
            question.answer_type
          end
          column "Actions" do |question|
            link_to("View", admin_questionnaire_section_question_path(questionnaire,section, question)) + "   " + link_to("Edit", edit_admin_questionnaire_section_question_path(questionnaire, section, question)) 
          end
        end
      end
    end
  end


end
