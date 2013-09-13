class Pick < ActiveRecord::Base

  belongs_to :week
  belongs_to :entry
  has_many :game_picks, dependent: :destroy

  accepts_nested_attributes_for :game_picks

end
