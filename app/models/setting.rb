class Setting < ApplicationRecord
  belongs_to :user
  attribute :font,             :string,  default: "OpenDyslexic"
  attribute :letter_spacing,   :string,  default: "0"
  attribute :font_size,        :string,  default: "12"
  attribute :syllable_mode,    :boolean, default: false
  attribute :syllable_palette, :string,  default: "blue_red_green"
end
