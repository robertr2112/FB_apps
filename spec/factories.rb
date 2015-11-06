FactoryGirl.define  do
  factory :user do
    sequence(:name)      { |n| "Person #{n}" }
    sequence(:user_name) { |n| "Nickname #{n}" }
    sequence(:email)     { |n| "person-#{n}@example.com" }
    password              "foobar"
    password_confirmation "foobar"
    confirmed             true

    factory :supervisor do
      supervisor true
      admin      true
    end
    
    factory :admin do
      admin true
    end

    factory :unconfirmed_user do
      confirmed false
    end
  end

  factory :pool do
    sequence(:name) { |n| "Pool-#{n}" }
    poolType              2
    isPublic              true
    password              "foobar"
  end

  # join table factory - :feature
  factory :pool_membership do |membership|
    membership.association :user
    membership.association :pool, :factory => :pool
  end
  
  factory :game do
    homeTeamIndex 1
    awayTeamIndex 17
    week
    
  end
  
  factory :entry do
    name              "entry 1"
    survivorStatusIn  true
    supTotalPoints    0

  end
  
  factory :week do
    state        0
    week_number  1
    season
    
    ignore do
      num_games  5
    end
    
    factory :week_with_games do
      
      after (:create) do |week, evaluator|
        home_games = (1..16).sort_by{rand}
        away_games = (17..32).sort_by{rand}
        1.upto(evaluator.num_games) do |n|
          create(:game, week: week, homeTeamIndex: home_games[n-1],
                                    awayTeamIndex: away_games[n-1])
        end
      end
    end
  end
  
  factory :season do
    year             "2015"
    state            0
    nfl_league       1
    current_week     1
    number_of_weeks  0
    
      ignore do
        num_weeks  1
        num_games  1
      end
      
    factory :season_with_weeks do
      
      after(:create) do |season, evaluator|
       1.upto(evaluator.num_weeks) do |n|
         create(:week, season: season, week_number: n)
       end
       season.number_of_weeks = evaluator.num_weeks
      end
    end
    
    factory :season_with_weeks_and_games do
      
      after(:create) do |season, evaluator|
       1.upto(evaluator.num_weeks) do |n|
         create(:week_with_games, season: season, week_number: n, num_games: evaluator.num_games)
       end
       season.number_of_weeks = evaluator.num_weeks
      end
    end
  end
  
end

