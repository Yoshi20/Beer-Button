class User < ApplicationRecord
  has_many :devices, dependent: :destroy
  has_many :orders, dependent: :destroy

  before_validation :strip_whitespace

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def strip_whitespace
    self.email.try(:strip!)
  end

  def admin?
    self.is_admin == true
  end

end
