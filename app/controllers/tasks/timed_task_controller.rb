class Tasks::TimedTaskController < ApplicationController
  before_action :authenticate_user

  def index
    home = current_user.homes.find(params[:home_id])
    timed_tasks = home.timed_tasks

    render json: timed_tasks
  end

  def show
    timed_task = current_user.timed_tasks.find(params[:id])

    render json: timed_task
  end

  def create
    home = current_user.homes.find(params[:home_id])
    create_timed_task = CreateTimedTask.new(home: home, params: timed_task_params)

    timed_task = create_timed_task.perform

    if create_timed_task.status
      render json: timed_task, status: :created
    else
      render json: timed_task.errors, status: :unprocessable_entity
    end
  end

  def update
    timed_task = current_user.timed_tasks.find(params[:id])
    update_timed_task = UpdateTimedTask.new(timed_task: timed_task, params: timed_task_params)

    timed_task = update_timed_task.perform

    if update_timed_task.status
      render json: timed_task
    else
      render json: timed_task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    timed_task = current_user.timed_tasks.find(params[:id])

    timed_task.destroy
  end

  private

  def timed_task_params
    timed_task_params = params.require(:timed_task).permit(:thing_id, :scenario_id, :cron)
    timed_task_params[:status] = params[:timed_task][:status]
    timed_task_params.permit!
  end
end
