class Thing < ApplicationRecord
  validates :type, :subtype, :connection_info, presence: true

  belongs_to :home
  delegate :user, to: :home

  def connection_info
    self[:connection_info]&.symbolize_keys
  end

  def status
    HTTParty.get(uri,
      headers: { "Content-Type" => "application/json" },
      query: connection_params)
  end

  def send_status(status)
    HTTParty.put(uri,
      headers: { "Content-Type" => "application/json" },
      query: connection_params,
      body: status.to_json)
  end

  protected

  def connection_params
    connection_info.merge(subType: subtype)
  end

  def uri
    # ...
  end
end
