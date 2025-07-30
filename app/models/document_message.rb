class DocumentMessage < ApplicationRecord
  belongs_to :document

  after_commit do
    broadcast_append_to(
      document,
      target: "document_#{document.id}_chat_box",
      partial: "document_messages/document_message",
      locals: { message: self }
    )
  end
end
