class TimedTaskSerializer < ActiveModel::Serializer
  attributes :id, :status, :cron
  has_one :thing
end
