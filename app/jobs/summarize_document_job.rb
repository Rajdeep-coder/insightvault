class SummarizeDocumentJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
    document.update!(status: "processing")

    prompt = "Summarize this document:\n\n#{document.extracted_text.truncate(2000)}"
    summary = IO.popen(["ollama", "run", "llama3", prompt]) { |io| io.read }

    document.update!(summary: summary, status: "done")
    Rails.logger.info "🔄 Updating summary + status"
  rescue => e
    document.update!(status: "failed")
    Rails.logger.error "Summary Job Failed: #{e.message}"
  end
end
