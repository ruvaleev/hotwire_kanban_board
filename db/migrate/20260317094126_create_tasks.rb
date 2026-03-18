class CreateTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :position, null: false, default: 0
      t.references :column, null: false, foreign_key: true

      t.timestamps
    end
  end
end
