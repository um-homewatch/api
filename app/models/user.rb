# This class represents the user model
# Users are composed of their homes, things, scenarios and tasks
class User < ApplicationRecord
  has_secure_password

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :homes
  has_many :things, through: :homes
  has_many :scenarios, through: :homes
  has_many :scenario_things, through: :scenarios
  has_many :timed_tasks, through: :homes
  has_many :triggered_tasks, through: :homes
end
