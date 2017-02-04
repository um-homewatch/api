class Home < ApplicationRecord
  validates :name, :location, :ip_address, presence: true
  validates :ip_address, uniqueness: true

  belongs_to :user
end
