class CreateColumns < ActiveRecord::Migration[8.1]
  def change
    create_table :columns do |t|
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
