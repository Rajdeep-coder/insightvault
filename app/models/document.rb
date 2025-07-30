class Document < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  has_many :document_messages, dependent: :destroy

  validates :file, presence: true

  after_update_commit -> {
    broadcast_replace_to self,
      target: "summary_frame_#{id}",
      partial: "documents/summary",
      locals: { document: self }
  }, if: -> { saved_change_to_summary? || saved_change_to_status? }
end
