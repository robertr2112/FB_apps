# == Schema Information
#
# Table name: entries
#
#  id               :integer          not null, primary key
#  pool_id          :integer
#  user_id          :integer
#  name             :string(255)
#  survivorStatusIn :boolean          default(TRUE)
#  supTotalPoints   :integer          default(0)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'rails_helper'

describe Entry do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:season) { FactoryGirl.create(:season_with_weeks) }

  before do
    @pool_attr = { :name => "Pool 1", :poolType => 2, 
                   :isPublic => true }
    @pool = user.pools.create(@pool_attr.merge(season_id: season.id,
                                   starting_week: 1)) 
    entry_name = @pool.getEntryName(user)
    @entry = 
      @pool.entries.create(user_id: user.id, name: entry_name,
                           survivorStatusIn: true, supTotalPoints: 0)
  end
  
  subject { @entry }
  
  it { should be_valid }
  
  it { should respond_to(:pool_id) }
  it { should respond_to(:user_id) }
  it { should respond_to(:name) }
  it { should respond_to(:survivorStatusIn) }
  it { should respond_to(:supTotalPoints) }
  it { should respond_to(:entryStatusGood?) }
  it { should respond_to(:madePicks?) }
  
  it "should have the right associated user" do
    @user_id = @entry.user_id
    expect(@user_id).to eq user.id
  end

  it "should have the right associated pool" do
    @pool_id = @entry.pool_id
    expect(@pool_id).to eq @pool.id
  end

  describe "survivorStatusIn is true then entryStatusGood?" do
    let(:entry) { FactoryGirl.create(:entry, survivorStatusIn: true) }
    
    it "should be true" do
      expect(entry.entryStatusGood?).to be true
    end
  end
  
  describe "survivorStatusIn is false then entryStatusGood?" do
    let(:entry) { FactoryGirl.create(:entry, survivorStatusIn: false) }
    
    it "should be false" do
      expect(entry.entryStatusGood?).to be false
    end
  end
  
  it "should test madePicks?"
  
end
