# This class represents the triggered task model, a task that is applied on a specific
# value change from another thing
class Tasks::TriggeredTask < ApplicationRecord
  include Task
  belongs_to :thing_to_compare, class_name: "Thing"
  valudates :status_to_compare, :status_to_apply, presence: true

  validate :thing_to_compare_must_belong_to_home

  def status
    status_to_apply
  end

  def status_to_compare
    self[:status_to_compare].symbolize_keys
  end

  def status_to_apply
    self[:status_to_apply].symbolize_keys
  end

  def apply_if
    comparison = thing_to_compare.compare(comparator, status_to_compare)

    if comparison && should_apply?
      apply
      update_attribute(:should_apply?, false)
    elsif !comparison
      update_attribute(:should_apply?, true)
    end
  end

  private

  def thing_to_compare_must_belong_to_home
    return unless home && thing
    return if home == thing.home

    errors.add(:thing_to_compare_id, "thing must belong to home")
  end
end
