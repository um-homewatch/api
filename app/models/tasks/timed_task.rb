class Tasks::TimedTask < ApplicationRecord
  belongs_to :thing
  belongs_to :home
  belongs_to :delayed_job, class_name: "::Delayed::Job", dependent: :destroy

  before_destroy :delete_job

  validate :thing_must_belong_to_user

  def cron
    delayed_job&.cron
  end

  def apply
    thing.send_status(status)
  end

  private

  def delete_job
    delayed_job.destroy
  end

  def thing_must_belong_to_user
    return if home && thing && thing.home == home

    errors.add(:thing_id, "thing must belong to this home")
  end
end
