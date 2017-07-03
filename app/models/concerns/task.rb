module Task
  extend ActiveSupport::Concern

  included do
    belongs_to :thing
    belongs_to :scenario
    belongs_to :home
    belongs_to :delayed_job, class_name: "::Delayed::Job", dependent: :destroy

    before_destroy :delete_job

    validate :thing_must_belong_to_home
    validate :must_have_scenario_or_thing_not_both
    validate :scenario_and_thing_cannot_be_empty

    def apply
      if thing
        thing.send_status(status)
      elsif scenario
        scenario.apply
      end
    end

    private

    def delete_job
      delayed_job.destroy
    end

    def thing_must_belong_to_home
      return unless home && thing
      return if thing.home == home

      errors.add(:thing_id, "thing must belong to this home")
    end

    def must_have_scenario_or_thing_not_both
      return unless scenario && thing

      errors.add(:thing_id, "task must activate a scenario or a thing, not both")
      errors.add(:scenario_id, "task must activate a scenario or a thing, not both")
    end

    def scenario_and_thing_cannot_be_empty
      return if scenario || thing

      errors.add(:thing_id, "must have a thing or a scenario")
      errors.add(:scenario_id, "must have a thing or a scenario")
    end
  end
end
