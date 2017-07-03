class Tasks::TriggeredTask < ApplicationRecord
  include Task
  belongs_to :thing_to_compare, class_name: "Thing"

  validate :thing_to_compare_must_belong_to_home

  def status
    status_to_apply
  end

  def apply_if
    apply if thing_to_compare.compare(comparator, status_to_compare)
  end

  private

  def thing_to_compare_must_belong_to_home
    return unless home && thing
    return if home == thing.home

    errors.add(:thing_to_compare_id, "thing must belong to home")
  end
end
