class AddTeamScores < ActiveRecord::Migration
  def change
    add_column :games, :homeTeamScore, :integer
    add_column :games, :awayTeamScore, :integer
  end
end
