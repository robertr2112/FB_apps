# == Schema Information
#
# Table name: game_picks
#
#  id              :integer          not null, primary key
#  pick_id         :integer
#  chosenTeamIndex :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class GamePick < ActiveRecord::Base

  belongs_to :pick

end
