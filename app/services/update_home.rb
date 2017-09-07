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

      raise ActiveRecord::Rollback if home.errors.count.positive?
    end

    home
  end

  private

  attr_reader :home, :params

  def delete_old_job
    home.delayed_job.destroy if home.delayed_job
  end

  def update_home
    home.update(params)

    home.delayed_job = home.delay(cron: HOME_TOKEN_UPDATE_CRON).fetch_token

    @status = home.save

    home.delay.fetch_token if status
  end
end
