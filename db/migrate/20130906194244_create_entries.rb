class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :user_id
      t.integer :week_id
      t.integer :total_score, default: 0
      t.boolean :survivor_status, default: true
      t.integer :sup_points, default: 0

      t.timestamps
    end
    add_index :entries, :user_id
  end
end
