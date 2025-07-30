class DocumentMessagesController < ApplicationController
  def create
    @document = Document.find(params[:document_id])
    @message = @document.document_messages.create!(
      role: "user",
      content: params[:document_message][:content]
    )

    GenerateDocumentReplyJob.perform_later(@document.id, @message.id)

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to @document }
    end
  end
end
