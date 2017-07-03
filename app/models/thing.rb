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

  def compare(comparator, status)
    return false unless VALID_COMPARATORS.include?(comparator)

    remote_status = setup_comparison_params(status)

    return false unless remote_status

    status.keys.each do |key|
      return false unless remote_status[key].send(comparator, status[key])
    end

    true
  rescue NoMethodError
    false
  end

  protected

  def connection_params
    connection_info.merge(subtype: subtype)
  end

  def uri
    # ...
  end

  private

  def setup_comparison_params(status)
    status = status.symbolize_keys!
    keys = status.keys

    return false unless (keys - returned_params).empty?
    return false unless (status.keys - keys).empty?
    remote_status = self.status.parsed_response&.symbolize_keys
    return false unless remote_status

    remote_status
  end
end
