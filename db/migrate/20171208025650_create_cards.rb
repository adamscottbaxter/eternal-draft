class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string :name, null: false
      t.integer :tier_id

      t.timestamps null: false
    end
  end
end
