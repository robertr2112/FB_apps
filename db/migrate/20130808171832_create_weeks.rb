class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.integer :state
      t.integer :pool_id

      t.timestamps
    end
  end
end
