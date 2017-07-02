class Tasks::TriggeredTask < ApplicationRecord
  include Task

  enum comparator_type: [:equals, :greater, :less]

  def status
    status_to_apply
  end

  def apply_if
    apply if thing.send(comparator_type, keys_to_compare, status_to_compare)
  end
end
