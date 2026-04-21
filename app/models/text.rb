class Text < ApplicationRecord
  belongs_to :user
  validate :content, presence: true
end
