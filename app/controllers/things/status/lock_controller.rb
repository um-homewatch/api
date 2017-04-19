class Things::Status::LockController < Things::StatusController
  private

  def fetch_thing
    home = Home.find(params[:home_id])
    home.things.find(params[:lock_id])
  end

  def status_params
    params.require(:status).permit(:locked)
  end
end