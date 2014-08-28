# == Schema Information
#
# Table name: pools
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  season_id       :integer
#  poolType        :integer
#  starting_week   :integer          default(1)
#  allowMulti      :boolean          default(FALSE)
#  isPublic        :boolean          default(TRUE)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Pool do

  before do
    @user_attr = {
      name: "Example User",
      email: "user@example.com",
      password: "foobar",
      password_confirmation: "foobar"
    }
    @pool_attr = { :name => "Pool 1", :poolType => 2, 
                   :isPublic => true }
    @user = User.create(@user_attr)
    @pool = @user.pools.create(@pool_attr)
  end

  subject { @pool }

  it { should respond_to(:name) }
  it { should respond_to(:poolType) }
  it { should respond_to(:isPublic) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:users) }
  it { should respond_to(:pool_memberships) }
  it { should respond_to(:weeks) }
  it { should respond_to(:isMember?) }
  it { should respond_to(:isOwner?) }
  it { should respond_to(:setOwner) }
  it { should respond_to(:addUser) }
  it { should respond_to(:removeUser) }

  it { should be_valid }

  it "should have the right associated user" do
    @user_id = @pool.users.last.id
    expect(@user_id).to eq @user.id
  end

  it "when pool name is already taken" do
    pool_with_duplicate_name = @user.pools.build(@pool_attr)
    expect(pool_with_duplicate_name).to_not be_valid
  end

  describe "when name is not present" do
    before { @pool.name =  " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @pool.name =  "a" * 31 }
    it { should_not be_valid }
  end

  describe "when poolType is invalid" do
    before { @pool.poolType = 4 }
    it { should_not be_valid }
  end

  describe "when isPublic is invalid" do
    before { @pool.isPublic = nil }
    it { should_not be_valid }
  end
end
