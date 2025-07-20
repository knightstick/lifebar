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

  private

  def task_params
    params.require(:task).permit(:name, :interval_type, :interval_value)
  end
end
