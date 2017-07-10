# This class represents the base model for all of the api supported devices/things
class Thing < ApplicationRecord
  VALID_COMPARATORS = ["==", "<", ">", ">=", "<="].freeze

  validates :name, :type, :subtype, :connection_info, presence: true

  belongs_to :home
  delegate :user, to: :home

  def allowed_params
    []
  end

  def returned_params
    []
  end

  def connection_info
    self[:connection_info].symbolize_keys
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

  def compare(comparator, status)
    return false unless VALID_COMPARATORS.include?(comparator)

    remote_status = setup_comparison_params(status)

    return false unless remote_status

    compare_remote_status
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

  def setup_comparison_params(status)
    status = status.symbolize_keys!

    return false unless (status.keys - returned_params).empty?

    remote_status = self.status.parsed_response
    return false unless remote_status

    remote_status.symbolize_keys
  end

  def compare_remote_status(remote_status, status)
    status.each do |key, value|
      return false unless remote_status[key].send(comparator, value)
    end

    true
  rescue NoMethodError
    false
  end
end
