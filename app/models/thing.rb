# This class represents the base model for all of the api supported devices/things
class Thing < ApplicationRecord
  include ThingComparator
  validates :name, :type, :subtype, :connection_info, presence: true

  belongs_to :home
  delegate :user, to: :home

  def self.types
    subclasses.map(&:name)
  end

  def allowed_params
    []
  end

  def returned_params
    []
  end

  def connection_info
    self[:connection_info]&.symbolize_keys
  end

  def status
    HTTParty.get(uri,
      headers: {
        "Content-Type" => "application/json",
        "TunnelAuthorization" => ENV["TUNNEL_ACCESS_TOKEN"],
      },
      query: connection_params,
      format: :json)
  end

  def send_status(status)
    HTTParty.put(uri,
      headers: {
        "Content-Type" => "application/json",
        "TunnelAuthorization" => ENV["TUNNEL_ACCESS_TOKEN"],
      },
      query: connection_params,
      body: status.to_json,
      format: :json)
  end

  protected

  def route
    # ...
  end

  private

  def connection_params
    connection_info.merge(subtype: subtype)
  end

  def uri
    home.tunnel + route
  end
end
