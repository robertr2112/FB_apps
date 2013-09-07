class CreateGamePicks < ActiveRecord::Migration
  def change
    create_table :game_picks do |t|
      t.integer :chosenTeamIndex

      t.timestamps
    end
  end
end
