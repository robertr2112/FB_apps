class CreatePools < ActiveRecord::Migration
  def change
    create_table :pools do |t|
      t.string :name
      t.integer :poolType
      t.boolean :isPublic, :default => true
      t.string :encrypted_password

      t.timestamps
    end
  end
end
