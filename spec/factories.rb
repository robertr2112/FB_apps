FactoryGirl.define  do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email){ |n| "person-#{n}@example.com" }
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
end

