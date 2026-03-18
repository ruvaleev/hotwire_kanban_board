# frozen_string_literal: true

class Board < ApplicationRecord
  has_many :columns, -> { order(:position) }, dependent: :destroy, inverse_of: :board

  validates :name, presence: true
end
