class AddTeamScores < ActiveRecord::Migration
  def change
    add_column :games, :homeTeamScore, :integer, default: 0
    add_column :games, :awayTeamScore, :integer, default: 0
  end
end
