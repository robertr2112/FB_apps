class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
      t.string :name
      t.integer :poolType
      t.boolean :isPublic, :default => true
      t.string :password_digest

      t.timestamps
    end
  end
end
