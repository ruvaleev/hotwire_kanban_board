# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_board
  before_action :set_column
  before_action :set_task, only: %i[edit update destroy move]

  def new
    @task = @column.tasks.build
  end

  def edit; end

  def create
    @task = @column.tasks.build(task_params)
    @task.position = (@column.tasks.maximum(:position) || 0) + 1

    if @task.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board }
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @board }
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @board }
    end
  end

  def move # rubocop:disable Metrics/MethodLength
    target_column = @board.columns.find(params[:target_column_id])
    @old_column = @task.column
    Task.suppressing_turbo_broadcasts do
      @task.update!(column: target_column, position: (target_column.tasks.maximum(:position) || 0) + 1)
    end

    Turbo::StreamsChannel.broadcast_render_to(
      [@board, 'tasks'],
      partial: 'tasks/move',
      locals: { task: @task, old_column: @old_column, board: @board }
    )

    respond_to do |format|
      format.turbo_stream do
        render partial: 'tasks/move', locals: { task: @task, old_column: @old_column, board: @board, show_flash: true }
      end
      format.html { redirect_to @board }
    end
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_column
    @column = @board.columns.find(params[:column_id])
  end

  def set_task
    @task = @column.tasks.find(params[:id])
  end

  def task_params
    params.expect(task: %i[title description])
  end
end
