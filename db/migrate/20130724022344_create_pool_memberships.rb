class CreatePoolMemberships < ActiveRecord::Migration
  def change
    create_table :pool_memberships do |t|
      t.integer :user_id
      t.integer :pool_id
      t.boolean :owner

      t.timestamps
    end
  end
end
