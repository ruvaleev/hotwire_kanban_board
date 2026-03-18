# frozen_string_literal: true

class Column < ApplicationRecord
  belongs_to :board
  has_many :tasks, -> { order(:position) }, dependent: :destroy, inverse_of: :column

  validates :name, presence: true

  broadcasts_to ->(column) { [column.board, 'columns'] }, insist: true
end
