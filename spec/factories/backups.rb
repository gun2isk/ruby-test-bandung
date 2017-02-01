FactoryGirl.define do
  factory :backup do
    profile nil
    version 1
    backup_time "2017-02-01 15:06:47"
    file_count 1
    new_file_count 1
    modified_file_count 1
  end
end
