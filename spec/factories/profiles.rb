FactoryGirl.define do
  factory :profile do
    user nil
    name "MyString"
    backup_dirs "MyText"
    backup_exclusion_dirs "MyText"
    last_backup "2017-02-01 14:49:20"
  end
end
