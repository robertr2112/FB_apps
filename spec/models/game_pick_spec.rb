# == Schema Information
#
# Table name: game_picks
#
#  id              :integer          not null, primary key
#  pick_id         :integer
#  game_pick_id    :integer
#  chosenTeamIndex :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'

describe GamePick do
  pending "add some examples to (or delete) #{__FILE__}"
end
