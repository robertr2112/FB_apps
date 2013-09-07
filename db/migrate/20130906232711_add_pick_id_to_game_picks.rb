class AddPickIdToGamePicks < ActiveRecord::Migration
  def change
    add_column :game_picks, :pick_id, :integer
  end
end
