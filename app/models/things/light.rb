# This class is responsible for representing devices of type "light"
class Things::Light < Thing
  def allowed_params
    [:on]
  end

  def returned_params
    [:on]
  end

  private

  def route
    "/devices/lights".freeze
  end
end
