# This class represents the home model
# It belongs to an user and is composed of devices, scenarios and tasks
class Home < ApplicationRecord
  validates :name, :location, :ip_address, :tunnel, presence: true
  validates :ip_address, uniqueness: true

  belongs_to :user
  belongs_to :delayed_job, class_name: "::Delayed::Job", dependent: :destroy
  has_many :things
  has_many :lights, class_name: "Things::Light"
  has_many :locks, class_name: "Things::Lock"
  has_many :thermostats, class_name: "Things::Thermostat"
  has_many :weathers, class_name: "Things::Weather"
  has_many :motion_sensors, class_name: "Things::MotionSensor"
  has_many :scenarios
  has_many :timed_tasks, class_name: "Tasks::TimedTask"
  has_many :triggered_tasks, class_name: "Tasks::TriggeredTask"

  def fetch_token
    token = HTTParty.get(token_uri,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => token,
      },
      format: :json).body

    update_attribute(:token, token)
  end

  private

  def token_uri
    tunnel + "/token"
  end
end
