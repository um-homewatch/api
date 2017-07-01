class Thing < ApplicationRecord
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

  def equals(keys, status)
    remote_status = setup_comparison_params(keys, status)
    return false unless remote_status

    keys.each do |key|
      return false unless status[key] == remote_status[key]
    end

    true
  rescue NoMethodError
    false
  end

  def greater(keys, status)
    remote_status = setup_comparison_params(keys, status)
    return false unless remote_status

    keys.each do |key|
      return false unless status[key] < remote_status[key]
    end

    true
  rescue NoMethodError
    false
  end

  def less(keys, status)
    remote_status = setup_comparison_params(keys, status)
    return false unless remote_status

    keys.each do |key|
      return false unless status[key] > remote_status[key]
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

  def setup_comparison_params(keys, status)    
    keys.map &:to_sym
    status.symbolize_keys

    return false unless (keys - returned_params).empty?
    return false unless (status.keys - keys).empty?
    remote_status = self.status.parsed_response&.symbolize_keys
    return false unless remote_status

    remote_status
  end
end
