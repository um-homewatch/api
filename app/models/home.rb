class Home < ApplicationRecord
  validates :name, :location, :ip_address, :tunnel, presence: true
  validates :ip_address, uniqueness: true

  belongs_to :user
  has_many :things
end
