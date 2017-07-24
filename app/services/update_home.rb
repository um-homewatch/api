# Service object to update home tasks
class UpdateHome
  attr_reader :status

  def initialize(home:, params:)
    @home = home
    @params = params.clone
    @status = false
  end

  def perform
    ActiveRecord::Base.transaction do
      delete_old_job

      update_home
    end

    home
  end

  private

  attr_reader :home, :params

  def delete_old_job
    home.delayed_job.destroy
  end

  def update_home
    home.update(params)

    home.delayed_job = home.delay(cron: HOME_TOKEN_UPDATE_CRON).fetch_token

    @status = home.save
  end
end
