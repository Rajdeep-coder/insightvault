class GenerateDocumentReplyJob < ApplicationJob
  queue_as :default

  def perform(document_id, user_message_id)
    document = Document.find(document_id)

    # Create placeholder "typing" assistant message
    typing_message = document.document_messages.create!(
      role: "assistant",
      content: nil,
      status: "typing"
    )

    # Generate AI reply (replace with your logic)
    user_content = document.document_messages.find(user_message_id).content
    context_text = document.summary.presence || document.extracted_text.to_s.truncate(3000)

    prompt = <<~PROMPT
      You are an expert assistant helping users understand documents.

      Use the following document content to answer the user's question as accurately as possible.
      Only rely on the content provided — do not make assumptions beyond it.

      ---
      📄 Document Content:
      #{context_text}
      ---

      🙋‍♂️ User Question:
      #{user_content}
    PROMPT

    reply = IO.popen([ "ollama", "run", "llama3", prompt ]) { |io| io.read }

    # Replace placeholder with actual reply
    typing_message.update!(
      content: reply,
      status: "done"
    )
  rescue => e
    Rails.logger.error "❌ AI reply failed: #{e.message}"
    typing_message&.update(status: "failed") if typing_message
  end
end
