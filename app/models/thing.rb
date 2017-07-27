# This class represents the base model for all of the api supported devices/things
class Thing < ApplicationRecord
  include ThingComparator
  validates :name, :type, :subtype, :connection_info, presence: true

  belongs_to :home
  has_many :timed_tasks, class_name: "Tasks::TimedTask", dependent: :destroy
  has_many :triggered_tasks, class_name: "Tasks::TriggeredTask", dependent: :destroy
  has_many :scenario_things, dependent: :destroy

  delegate :user, to: :home

  def allowed_params
    []
  end

  def returned_params
    []
  end

  def connection_info
    self[:connection_info]&.symbolize_keys
  end

  def read_only?
    allowed_params.empty?
  end

  def status
    HTTParty.get(uri,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => home.token,
      },
      query: connection_params,
      format: :json)
  end

  def send_status(status)
    HTTParty.put(uri,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => home.token,
      },
      query: connection_params,
      body: status.to_json,
      format: :json)
  end

  def self.types
    subclasses.map(&:name)
  end

  def self.route
    # ...
  end

  private

  def connection_params
    connection_info.merge(subtype: subtype)
  end

  def uri
    home.tunnel + self.class.route
  end
end
