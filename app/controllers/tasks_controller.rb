class TasksController < ApplicationController
  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: "Task created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @tasks = Task.all
  end

  def complete
    @task = Task.find(params[:id])
    @task.mark_completed!
    redirect_to tasks_path, notice: "Task completed successfully"
  rescue ActiveRecord::RecordNotFound
    redirect_to tasks_path, alert: "Task not found"
  rescue StandardError => e
    Rails.logger.error "Error completing task #{params[:id]}: #{e.message}"
    redirect_to tasks_path, alert: "Unable to complete task. Please try again."
  end

  private

  def task_params
    params.require(:task).permit(:name, :interval_type, :interval_value)
  end
end
