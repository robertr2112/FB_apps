# == Schema Information
#
# Table name: picks
#
#  id          :integer          not null, primary key
#  week_id     :integer
#  entry_id    :integer
#  week_number :integer
#  totalScore  :integer          default(0)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Pick do
  pending "add some examples to (or delete) #{__FILE__}"
end
