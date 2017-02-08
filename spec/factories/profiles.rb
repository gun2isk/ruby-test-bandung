FactoryGirl.define do
  factory :profile do
    association :user

    name { Faker::Lorem.sentence(1) }
    backup_dirs { "#{Rails.root}/public/source-examples1\r\n#{Rails.root}/public/source-examples2" }
    last_backup "2017-02-01 14:49:20"
  end
end
