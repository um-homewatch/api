# This class is responsible for representing devices of type "light"
class Things::Light < Thing
  def allowed_params
    [:on].freeze
  end

  def returned_params
    [:on].freeze
  end

  def self.route
    "/devices/lights".freeze
  end
end
