class Text < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  has_one_attached :document
end
