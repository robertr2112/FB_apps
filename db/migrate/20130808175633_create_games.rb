class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :homeTeamIndex
      t.integer :awayTeamIndex
      t.integer :spread
      t.integer :week_id

      t.timestamps
    end
  end
end
