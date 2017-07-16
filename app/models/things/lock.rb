# This class is responsible for representing devices of type "lock"
class Things::Lock < Thing
  def allowed_params
    [:locked]
  end

  def returned_params
    [:locked]
  end

  def self.route
    "/devices/locks".freeze
  end
end
