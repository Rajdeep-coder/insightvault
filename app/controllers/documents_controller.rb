# app/controllers/documents_controller.rb
class DocumentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @documents = current_user.documents
  end

  def new
    @document = current_user.documents.new
  end

  def create
    @document = current_user.documents.new(document_params)

    if @document.save
      extract_text_from_pdf(@document)
      redirect_to @document, notice: "Uploaded successfully!"
    else
      render :new
    end
  end

  def show
    @document = current_user.documents.find(params[:id])
  end

  def destroy
    @document = Document.find(params[:id])
    @document.destroy
    redirect_to dashboard_path, notice: "Document deleted successfully."
  end

  def summarize
    @document = current_user.documents.find(params[:id])

    SummarizeDocumentJob.perform_later(@document.id)

    respond_to do |format|
      format.turbo_stream { head :ok }
      format.html { redirect_to @document }
    end
  end

  private

  def document_params
    params.require(:document).permit(:title, :file)
  end

  def extract_text_from_pdf(document)
    require "pdf-reader"

    file = document.file.download
    reader = PDF::Reader.new(StringIO.new(file))

    full_text = reader.pages.map(&:text).join("\n")
    document.update(extracted_text: full_text)
  end
end
