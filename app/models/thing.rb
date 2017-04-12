class Thing < ApplicationRecord
  enum type: %i[LIGHT LOCK WEATHER THERMOSTAT]

  belongs_to :home
  has_one :user, through: :home
end
