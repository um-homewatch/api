class Thing < ApplicationRecord
  validates :type, :subtype, :connection_info, presence: true

  belongs_to :home
  delegate :user, to: :home

  def connection_info
    self[:connection_info]&.symbolize_keys
  end
end
