# This class is a concern that contains all the shared functionality of tasks
# A task belongs to a thing, a scenario and a home. It also has a delayed job.
# A task can be applied, updating the associated thing with a given status
# Tasks can belong to a scenario and a thing, but not both.
module Task
  extend ActiveSupport::Concern

  included do
    belongs_to :thing
    belongs_to :scenario
    belongs_to :home
    belongs_to :delayed_job, class_name: "::Delayed::Job", dependent: :destroy

    before_destroy :delete_job

    validate :thing_must_not_be_read_only
    validate :thing_must_belong_to_home
    validate :must_have_scenario_or_thing_not_both
    validate :must_have_status_to_apply_if_thing
    validate :scenario_and_thing_cannot_be_empty
    validate :status_to_apply_params_equals_thing_params

    def status_to_apply
      self[:status_to_apply].symbolize_keys if self[:status_to_apply]
    end

    def apply
      if thing
        thing.send_status(status_to_apply)
      elsif scenario
        scenario.apply
      end
    end

    private

    def delete_job
      delayed_job.destroy
    end

    def thing_must_not_be_read_only
      return unless thing && thing.read_only?

      errors.add(:thing, "read only thing")
    end

    def thing_must_belong_to_home
      return unless home && thing
      return if thing.home == home

      errors.add(:thing_id, "thing must belong to this home")
    end

    def must_have_scenario_or_thing_not_both
      return unless scenario && thing

      errors.add(:thing_id, "must activate a scenario or a thing, not both")
      errors.add(:scenario_id, "must activate a scenario or a thing, not both")
    end

    def must_have_status_to_apply_if_thing
      return unless thing && !status_to_apply

      errors.add(:status_to_apply, "can't be blank")
    end

    def scenario_and_thing_cannot_be_empty
      return if scenario || thing

      errors.add(:thing_id, "must have a thing or a scenario")
      errors.add(:scenario_id, "must have a thing or a scenario")
    end

    def status_to_apply_params_equals_thing_params
      return unless thing && status_to_apply && status_to_apply.keys != thing.allowed_params

      errors.add(:status_to_apply, "not a valid status for this thing type")
    end
  end
end
