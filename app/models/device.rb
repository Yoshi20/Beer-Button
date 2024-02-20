class Device < ApplicationRecord
  belongs_to :user
  belongs_to :device_type
  has_many :orders, dependent: :destroy

  validates :name, :dev_eui, presence: true

  def type
    self.device_type.name
  end

end
