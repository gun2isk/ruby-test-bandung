FactoryGirl.define do
  sequence :name do |n|
    "#{n}.txt"
  end

  factory :backup_file do
    association :backup

    kind { BackupFile::KINDS.sample }
    parent_dir "/files-examples/"
    path { "/files-examples/#{name}" }
    name
    file_type "text/plain"
    file_size 0
    last_modified Time.now
    status 'new'
    gid 100
    uid 100

    trait :directory do
      kind 'directory'
    end    

    trait :file do
      kind 'file'
    end

    trait :new_file do
      status 'new'
    end    

    trait :modified_file do
      status 'changed'
    end    
  end
end
