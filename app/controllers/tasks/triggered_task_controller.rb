class Tasks::TimedTaskController < ApplicationController
  before_action :authenticate_user

  def index
    home = current_user.homes.find(params[:home_id])
    triggered_tasks = home.triggered_tasks

    render json: triggered_tasks
  end

  def show
    triggered_task = current_user.triggered_tasks.find(params[:id])

    render json: triggered_task
  end

  def create
    home = current_user.homes.find(params[:home_id])
    create_triggered_task = CreateTriggeredTask.new(home: home, params: triggered_task_params)

    triggered_task = create_triggered_task.perform

    if create_triggered_task.status
      render json: triggered_task, status: :created
    else
      render json: triggered_task.errors, status: :unprocessable_entity
    end
  end

  def update
    triggered_task = current_user.triggered_tasks.find(params[:id])
    update_triggered_task = UpdateTriggeredTask.new(triggered_task: triggered_task, params: triggered_task_params)

    triggered_task = update_triggered_task.perform

    if update_triggered_task.status
      render json: triggered_task
    else
      render json: triggered_task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    triggered_task = current_user.triggered_tasks.find(params[:id])

    triggered_task.destroy
  end

  private

  def triggered_task_params
    triggered_task_params = params.require(:triggered_task).permit(:thing_id, :scenario_id, :cron)
    triggered_task_params[:status] = params[:triggered_task][:status]
    triggered_task_params.permit!
  end
end
