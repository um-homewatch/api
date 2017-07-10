# This class represents the base model
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
