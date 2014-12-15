class EvaluationsController < ApplicationController

  def edit
    @evaluation = Evaluation.find_by_access_key(params[:evaluation_id])
    completed_self_eval = @evaluation.completed? && @evaluation.self_eval?
    completed_peer_eval = @evaluation.completed? && !@evaluation.self_eval?
    render plain: "404 Not Found", status: 404 and return if @evaluation.nil?

    if completed_self_eval
      redirect_to invitations_path(@evaluation.participant)
    end

    if completed_peer_eval
      redirect_to thank_you_path
    end

    if !@evaluation.completed?
      render :edit
    end
  end
    

  def update
    evaluation = Evaluation.find_by_access_key(params[:id])
    evaluation.update!(evaluation_params)
    participant = evaluation.participant
    submitting_self_eval = (params[:commit] == "Submit" &&
                            evaluation.self_eval?)
    submitting_peer_eval = (params[:commit] == "Submit" &&
                            !evaluation.self_eval?)
    saving = (params[:commit] == "Save For Later")
    
    if submitting_self_eval 
      participant.completed_self_eval
      redirect_to invitations_path participant
    end
    
    if submitting_peer_eval 
      participant.peer_evaluation_completed(evaluation)
      redirect_to thank_you_path
    end

    if saving
      flash[:notice] = "Your responses have been saved"
      redirect_to edit_evaluation_path(evaluation)
    end

  end
  
  private
    def evaluation_params
      params.require(:evaluation).permit(answers_attributes: [:numeric_response, :text_response, :id])
    end
end
