class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.tasks.ransack(params[:q])
    @tasks = @q.result(distinct: true).page(params[:page])

    if params[:tag_name]
      @tasks = @tasks.tagged_with("#{params[:tag_name]}")
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      redirect_to @task, notice: "タスク「#{@task.name}」を登録しました。"
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_url, notice: "タスク「#{@task.name}」を更新しました。"
    else
      redirect_to tasks_url, notice: "タスク「#{@task.name}」の更新に失敗しました。"
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: "タスク「#{@task.name}」を削除しました。"
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :deadline, :status, :priority ,:tag_list)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
