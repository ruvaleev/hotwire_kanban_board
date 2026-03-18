# frozen_string_literal: true

class BoardsController < ApplicationController
  before_action :set_board, only: %i[show edit update destroy]

  def index
    @boards = Board.all
  end

  def show; end

  def new
    @board = Board.new
  end

  def edit; end

  def create
    @board = Board.new(board_params)

    if @board.save
      redirect_to @board, notice: 'Board was successfully created.'
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @board.update(board_params)
      redirect_to @board, notice: 'Board was successfully updated.'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @board.destroy!
    redirect_to boards_url, notice: 'Board was successfully deleted.'
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.expect(board: [:name])
  end
end
