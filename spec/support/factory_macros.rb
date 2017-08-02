# This module contains method to complement
# FactoryGirl functionalities
module FactoryMacros
  def attributes_with_foreign_keys(*args)
    instance = FactoryGirl.build(*args)

    delete_unneeded_attributes(instance)
    fetch_enums(instance)

    deep_symbolize instance.attributes
  end

  private

  def delete_unneeded_attributes(instance)
    instance.attributes.delete_if { |k, _v| params_to_delete(instance).member?(k) }
  end

  def params_to_delete(instance)
    if instance.class.name == "Thing"
      %w[id created_at updated_at].freeze
    else
      %w[id type created_at updated_at].freeze
    end
  end

  def fetch_enums(instance)
    instance.class.defined_enums.each { |k, _v| instance.attributes[k] = instance.send(k) }
  end

  def deep_symbolize(json)
    if json.is_a? Array
      json.map(&:deep_symbolize_keys)
    else
      json.deep_symbolize_keys
    end
  end
end
