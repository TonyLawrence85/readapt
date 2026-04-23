class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  validates :content, presence: true, unless: :document_attached?
  has_one_attached :document
  validate :document_must_be_pdf, if: :document_attached?

  private

  def document_attached?
    document.attached?
  end

  def document_must_be_pdf
    unless document.content_type == "application/pdf"
      errors.add(:document, "doit être un fichier PDF")
    end
  end
end
