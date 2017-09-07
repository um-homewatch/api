# Service object to create homes
class CreateHome
  attr_reader :status

  def initialize(user:, params:)
    @user = user
    @params = params.clone
    @status = false
  end

  def perform
    @home = user.homes.build(params)

    ActiveRecord::Base.transaction do
      create_job

      raise ActiveRecord::Rollback if home.errors.count.positive?
    end

    home
  end

  private

  attr_reader :user, :params, :home

  def create_job
    return unless home.save

    home.delayed_job = home.delay(cron: HOME_TOKEN_UPDATE_CRON).fetch_token

    @status = home.save

    home.delay.fetch_token if status
  end
end
