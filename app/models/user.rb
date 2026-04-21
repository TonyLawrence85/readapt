class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :texts
  has_one :setting

  after_create :create_default_setting

  private

  def create_default_setting
    Setting.create!(user: self)
  end
end
