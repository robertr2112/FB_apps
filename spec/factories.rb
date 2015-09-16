FactoryGirl.define  do
  factory :user do
    sequence(:name)      { |n| "Person #{n}" }
    sequence(:user_name) { |n| "Nickname #{n}" }
    sequence(:email)     { |n| "person-#{n}@example.com" }
    password              "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :pool do
    sequence(:name) { |n| "Pool-#{n}" }
    poolType              "0"
    isPublic              "t"
    password              "foobar"
  end

  # join table factory - :feature
  factory :pool_membership do |membership|
    membership.association :user
    membership.association :pool, :factory => :pool
  end
  
  factory :week do
    state        0
    week_number  1
    season
  end
  
  factory :season do
    year             "2015"
    state            0
    nfl_league       1
    current_week     1
    number_of_weeks  1
    factory :season_with_weeks do
      
      ignore do
        num_weeks  1
      end
      
      after(:create) do |season, evaluator|
       create_list(:week, evaluator.num_weeks, season: season)
       season.number_of_weeks = evaluator.num_weeks
      end
    end
  end
  
end

