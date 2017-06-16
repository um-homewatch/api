class User < ApplicationRecord
  has_secure_password

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :homes
  has_many :things, through: :homes
  has_many :scenarios, through: :homes
  has_many :timed_tasks, through: :homes
end
