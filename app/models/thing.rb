class Thing < ApplicationRecord
  enum kind: %i[LIGHT LOCK WEATHER THERMOSTAT]

  validates :kind, :subtype, :payload, presence: true

  belongs_to :home
  delegate :user, to: :home
end
