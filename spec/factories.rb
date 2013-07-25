# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define  do
  factory :user do |user|
    user.name                   "Michael Hartl"
    user.email                  "mhartl@example.com"
    user.password               "foobar"
    user.password_confirmation  "foobar"
  end

  factory :pool do |pool|
    pool.name                   "Pool1"
    pool.poolType               "2"
    pool.isPublic               "t"
    pool.password               "foobar"
  end

  sequence :email do |n|
    "person-#{n}@example.com"
  end
end

