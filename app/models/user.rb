class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders

  validates :email, uniqueness: true
  validates :email, presence: true
  validates :password, presence: true, allow_blank: true
  validates_format_of :email,:with => Devise::email_regexp

  

end
