# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :column

  validates :title, presence: true

  broadcasts_to ->(task) { [task.column.board, 'tasks'] }, insist: true

  delegate :board, to: :column
end
