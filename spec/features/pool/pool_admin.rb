require 'rails_helper'

feature "Pool Admin" do
  scenario "Creating a new pool" do
    given_I_am_a_logged_in_user
    and_a_season_has_been_created
    when_I_create_a_pool
    then_the_pool_should_show_up_in_my_profile
  end
  
  scenario "Updating the pool name" do
    given_I_am_a_logged_in_user
    and_a_season_has_been_created
    and_I_have_created_a_pool
    when_I_update_the_pool_name
    then_the_new_pool_name_should_be_in_my_profile
  end
  
  scenario "Deleting a pool" do
    given_I_am_a_logged_in_user
    and_a_season_has_been_created
    and_I_have_created_a_pool
    when_I_delete_a_pool
    then_the_pool_should_not_show_up_in_my_profile
    
  end
  
  # Given Definitions
  
  def given_I_am_a_logged_in_user
#    @user =  FactoryGirl.create(:user)
    @user =  FactoryBot.create(:admin)
    sign_in @user
  end
  
  # And Definitions
  
  def and_a_season_has_been_created
    @season = FactoryBot.create(:season_with_weeks_and_games, num_weeks: 4, num_games: 4)
    @season.setState(Season::STATES[:Open])
  end
  
  def and_I_have_created_a_pool
  end
  
  # When Definitions
  
  def when_I_create_a_pool
    visit new_pool_path
    fill_in 'pool_name',       with: "Test Pool"
    click_button 'Create pool'
    save_and_open_page
    
  end
  
  def when_I_update_the_pool_name
  end
  
  def when_I_delete_a_pool
  end
  
  # Then Definitions
  
  def then_the_pool_should_show_up_in_my_profile
  end
  
  def then_the_new_pool_name_should_be_in_my_profile
  end
  
  def then_the_pool_should_not_appear_in_my_profile
  end
  
end
