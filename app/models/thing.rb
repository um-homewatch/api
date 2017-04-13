class Thing < ApplicationRecord
  self.inheritance_column = nil

  enum type: %i[LIGHT LOCK WEATHER THERMOSTAT]

  validates :type, :subtype, :payload, presence: true

  belongs_to :home
  delegate :user, to: :home
end
