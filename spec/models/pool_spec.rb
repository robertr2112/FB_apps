# == Schema Information
#
# Table name: pools
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  poolType           :integer
#  isPublic           :boolean          default(TRUE)
#  encrypted_password :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'spec_helper'

describe Pool do

  let(:user) { FactoryGirl.create(:user) }
  before do
    # This code is not idiomatically correct.
    @pool = user.pools.build(name: "Pool 1", 
                             poolType: Pool::Pool_TYPES[:pickEm],
                             isPublic: true,
                             pasword: "foobar")
  end
 
  subject { @pool }

  it { should respond_to(:name) }
  it { should respond_to(:poolType) }
  it { should respond_to(:isPublic) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

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
  end

  it "should create a new instance given valid attributes" do
    @user.pools.create!(@pool_attr)
  end

  describe "user associations" do

    before(:each) do
      @pool = @user.pools.create(@pool_attr)
    end

    it "should have a users attribute" do
      @pool.should respond_to(:users)
    end

    it "should have the right associated user" do
      @user_id = @pool.users.last.id
      @user_id.should == @user_id
    end
  end

  describe "validations" do
    it "should require a unique name" do
      @user.pools.create!(@pool_attr)
      pool_with_duplicate_name = @user.pools.build(@pool_attr)
      pool_with_duplicate_name.should_not be_valid
    end

    it "should require nonblank content" do
      @user.pools.build(:name => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.pools.build(:name => "a" * 31).should_not be_valid
    end

    it "should reject invalid poolType" do
      @user.pools.build(@pool_attr.merge(:poolType => 4)).should_not be_valid
    end

    it "should reject invalid isPublic boolean" do
      @user.pools.build(@pool_attr.merge(:isPublic => nil)).should_not be_valid
    end
  end
end
