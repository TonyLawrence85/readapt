class Setting < ApplicationRecord
  belongs_to :user
  attribute :font, :string, default: "OpenDyslexic"
end
