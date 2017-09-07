# This module is responsible for the comparation methods
# on things
module ThingComparator
  extend ActiveSupport::Concern

  included do
    VALID_COMPARATORS = ["==", "<", ">", ">=", "<="].freeze

    def compare(comparator, status)
      return false unless VALID_COMPARATORS.include?(comparator)

      remote_status = setup_comparison_params(status)

      return false unless remote_status

      compare_remote_status(remote_status, status, comparator)
    end

    private

    def setup_comparison_params(status)
      status = status.symbolize_keys!

      return false unless (status.keys - returned_params).empty?

      remote_status = self.status.body_json
      return false unless remote_status

      remote_status.symbolize_keys
    end

    def compare_remote_status(remote_status, status, comparator)
      status.each do |key, value|
        return false unless remote_status[key].send(comparator, value)
      end

      true
    rescue NoMethodError
      false
    end
  end
end
