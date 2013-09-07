class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.integer :user_id
      t.integer :week_id
      t.integer :total_score
      t.boolean :survivor_status
      t.integer :sup_points

      t.timestamps
    end
    add_index :picks, :user_id
  end
end
