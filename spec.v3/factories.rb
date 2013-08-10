# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define  do
  factory :user do |user|
    user.name                   "Michael Hartl"
    sequence(:email) {|n| "person-#{n}@example.com"}
    user.password               "foobar"
    user.password_confirmation  "foobar"
  end

  factory :pool do |pool|
    sequence(:name) {|n| "Pool-#{n}"}
    pool.poolType               "0"
    pool.isPublic               "t"
    pool.password               "foobar"
  end

  # join table factory - :feature
  factory :pool_membership do |membership|
    membership.association :user
    membership.association :pool, :factory => :pool
  end 

# sequence :email do |n|
#   "person-#{n}@example.com"
# end

# sequence :name do |n|
#   "Pool-#{n}"
# end

end

