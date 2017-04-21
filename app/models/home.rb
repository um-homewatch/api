class Home < ApplicationRecord
  validates :name, :location, :ip_address, :tunnel, presence: true
  validates :ip_address, uniqueness: true

  belongs_to :user
  has_many :things
  has_many :lights, class_name: "Things::Light"
  has_many :locks, class_name: "Things::Lock"
  has_many :thermostats, class_name: "Things::Thermostat"
  has_many :weathers, class_name: "Things::Weather"
  has_many :scenarios
end
