class Game < ActiveRecord::Base

  belongs_to :week

  attr_accessible :awayTeamIndex, :homeTeamIndex, :spread

  validates :homeTeamIndex, :inclusion => { :in => 0..100 }
  validates :awayTeamIndex, :inclusion => { :in => 0..100 }
end
