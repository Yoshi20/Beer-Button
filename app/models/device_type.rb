class DeviceType < ApplicationRecord
  has_many :devices, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :number_of_buttons, presence: true

end
