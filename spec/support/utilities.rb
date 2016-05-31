module AuthenticationHelper

  def sign_in(user, options={})
    if options[:no_capybara]
      # Sign in when not using Capybara.
      remember_token = User.new_remember_token
      cookies[:remember_token] = remember_token
      user.update_attribute(:remember_token, User.encrypt(remember_token))
    else
      visit signin_path
      find('#signin_email').set(user.email)
      find('#signin_password').set(user.password)
      find('#signin_button').click
    end
  end

  #  Here are the support routines to test out pools
 
  # add scores for all games and all weeks in the season, where all home teams win (for simplicity)
  # for each week, but leave current week as 1 and don't mark any weeks as final
  def add_season_games_scores(season)
    season.weeks.each do |week|
      puts "week number: #{week.week_number}"
      week.games.each do |game|
        game.homeTeamScore = rand(18...42)
        game.awayTeamScore = rand(0...17)
        puts "game.id: #{game.id}, homeTeamScore: #{game.homeTeamScore}, awayTeamScore: #{game.awayTeamScore}"
        puts "homeTeam: #{game.homeTeamIndex}, awayTeam: #{game.awayTeamIndex}"
      end
    end
  end
   
  # will setup a pool with num_users number of users and num_entries number of
  # entries per user in entered season
  def setup_pool_with_users_and_entries(season, num_users, num_entries)
    users = Array.new
    users[0] = FactoryGirl.create(:user_with_pool_and_entry, season: season)
    pool = users[0].pools.first
    1.upto(4) do |n|
      users[n] = FactoryGirl.create(:user_with_pool_and_entry, season: season, pool: pool)
    end
    return users
  end
 
  # Have num_users number of users pick the winning home team and the rest pick the away team
  def users_pick_winning_team(week, pool, users, num_users)
    
    user_count = 1
    users.each do |user|
      entry = pool.entries.where(user_id: user.id)[0]
      if user_count <= num_users then 
        team_index = week.games[0].homeTeamIndex
      else
        team_index = week.games[0].awayTeamIndex
      end
      pick = FactoryGirl.create(:pick_with_game_pick, entry: entry,  week_id: week.id, 
                                 week_number: week.week_number, teamIndex: team_index)
      user_count += 1
    end
  end
  
  def numberRemainingSurvivorEntries(pool)
    
    num_entries = 0
    pool.entries.each do |entry|
      puts "entry.id: #{entry.id}, survivorStatusIn: #{entry.survivorStatusIn}"
      if entry.survivorStatusIn then
        num_entries += 1
      end
    end
    puts "num_entries: #{num_entries}"
    return num_entries
  end
 
#module MailerMacros
#  def last_email
#    ActionMailer::Base.deliveries.last
#  end
#	
#  def extract_token_from_email(token_name)
#    mail_body = last_email.body.to_s
#    mail_body[/#{token_name.to_s}_token=([^"]+)/, 1]
#  end

 #
 # Debug code
 #
 #save_and_open_page
 #puts current_url
 #pry
 
end


