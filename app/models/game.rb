# == Schema Information
#
# Table name: games
#
#  id            :integer          not null, primary key
#  homeTeamIndex :integer
#  awayTeamIndex :integer
#  spread        :integer
#  week_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class Game < ActiveRecord::Base

  belongs_to :week

  validates :homeTeamIndex, :inclusion => { :in => 0..100 }
  validates :awayTeamIndex, :inclusion => { :in => 0..100 }

  def wonGame?(teamIndex)
    spread = self.awayTeamScore - self.homeTeamScore
    if spread < 0
      winTeamIndex = self.homeTeamIndex
    else
      winTeamIndex = self.awayTeamIndex
    end
    teamIndex == winTeamIndex
  end
end
