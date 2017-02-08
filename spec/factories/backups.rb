FactoryGirl.define do
  sequence :version do |n|
    n
  end
  
  factory :backup do
    association :profile

    version { generate(:version) }
    backup_time Time.now
    file_count 0
    new_file_count 0
    modified_file_count 0
  end
end
