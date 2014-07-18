# == Schema Information
#
# Table name: picks
#
#  id         :integer          not null, primary key
#  week_id    :integer
#  entry_id   :integer
#  weekNumber :integer
#  totalScore :integer          default(0)
#  created_at :datetime
#  updated_at :datetime
#

class Pick < ActiveRecord::Base

  belongs_to :week
  belongs_to :entry
  has_many :game_picks, dependent: :destroy

  accepts_nested_attributes_for :game_picks

  validate :pickValid?


  def pickValid?
    current_game_pick = self.game_picks.first
    entry = Entry.find(self.entry_id)
    entry.picks.each do |pick|
      old_game_pick = pick.game_picks.first
      if (old_game_pick != current_game_pick &&
          old_game_pick.chosenTeamIndex == current_game_pick.chosenTeamIndex)
        errors[:base] << "You have already picked this team!  Please choose another team."
        current_game_pick.errors[:chosenTeamIndex] << "You have already picked this team!  Please choose another team."
      end
    end
  end
  
end
