# This module contains several utilities to be used on api
# documentation testing
module RequestMacros
  def token_for(user = nil)
    user ||= FactoryGirl.create(:user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end
end
