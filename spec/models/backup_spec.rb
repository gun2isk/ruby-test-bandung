require 'rails_helper'

RSpec.describe Backup, type: :model do
  it { should belong_to(:profile) }
  it { should have_many(:files).class_name('BackupFile').dependent(:destroy) }

  it { should validate_presence_of(:profile) }
  it { should validate_presence_of(:version) }
  it { should validate_presence_of(:backup_time) }
  it { should validate_uniqueness_of(:version).scoped_to(:profile_id) }

  before(:each) do
    DatabaseCleaner.clean
  end

  let(:backup) { build(:backup) }

  describe '#storage_path' do
    it 'should return path for the storage directory' do
      backup.profile_id = 1
      backup.version = 1

      expect(backup.storage_path).to eq("#{Backup::BASE_STORAGE_PATH}/profile-1/v1/")
    end
  end

  describe '#version_name' do
    it 'should return version name' do
      backup.version = 1
      backup.backup_time = Time.now

      expect(backup.version_name).to eq("Version 1 - #{backup.backup_time.strftime("%Y-%m-%d %H:%M")}")
    end
  end

  describe '#update_backup_attrs' do
    before(:all) do
      DatabaseCleaner.clean

      @backup = create(:backup)
      @new_files_count = 10
      @modified_files_count = 5

      @new_files_count.times.each { build(:backup_file, :file, :new_file, backup: @backup).save(validate: false) }
      @modified_files_count.times.each { build(:backup_file, :file, :modified_file, backup: @backup).save(validate: false) }

      @backup.update_backup_attrs
    end

    it 'should update #file_count to be total of files' do
      expect(@backup.file_count).to eq(@new_files_count + @modified_files_count)
    end

    it 'should update #new_file_count to be total of new files only' do
      expect(@backup.new_file_count).to eq(@new_files_count)
    end

    it 'should update #modified_file_count to be total of modified files only' do
      expect(@backup.modified_file_count).to eq(@modified_files_count)
    end
  end

  describe '#remove_storage on before_destroy' do
    it 'should remove directory storage' do
      backup = create(:backup)

      FileUtils.mkdir_p(backup.storage_path) ## simulate create storage directory

      expect(File.exist?(backup.storage_path)).to eq(true)

      backup.destroy

      expect(File.exist?(backup.storage_path)).to eq(false)
    end
  end
end
