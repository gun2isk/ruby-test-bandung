require 'rails_helper'
require 'mime/types'

RSpec.describe BackupFile, type: :model do
  it { should belong_to(:backup) }

  it { should validate_presence_of(:backup) }
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:path) }
  it { should validate_presence_of(:parent_dir) }
  it { should validate_presence_of(:name) }
  
  before(:all) do 
    Profile.skip_callback(:create, :after, :run_backup)
    BackupFile.skip_callback(:validation, :before, :check_history)
  end

  describe 'scopes' do
    before(:all) do
      DatabaseCleaner.clean

      backup = build(:backup)

      3.times.each { create(:backup_file, :new_file, backup: backup) }
      4.times.each { create(:backup_file, :modified_file, backup: backup) }
    end

    describe '.new_files' do
      it 'should return only BackupFile with #status is "new"' do
        expect(BackupFile.new_files.count).to eq(3)
      end
    end

    describe '.changed_files' do
      it 'should return only BackupFile with #status is "changed"' do
        expect(BackupFile.changed_files.count).to eq(4)
      end
    end
  end

  describe '#storage_path' do
    it 'should return path of location storage' do
      file = create(:backup_file, :file)

      expect(file.storage_path).to eq("#{Backup::BASE_STORAGE_PATH}/profile-#{file.backup.profile_id}/v#{file.backup.version}#{file.path}")
    end
  end

  describe '#is_directory?' do
    it 'should check if BackupFile is a directory' do
      directory = create(:backup_file, :directory)

      expect(directory.is_directory?).to eq(true)
    end
  end

  describe '#is_file?' do
    it 'should check if BackupFile is a file' do
      file = create(:backup_file, :file)

      expect(file.is_file?).to eq(true)
    end
  end

  describe '#restore_file' do
    before(:all) do
      profile = create(:profile)
      backup_v1 = create(:backup, profile: profile, version: 1)
      backup_v2 = create(:backup, profile: profile, version: 2)

      restore_file = create(:backup_file)
      backup_file = create(:backup_file, :file)
    end

    it 'should replace the file with certain version file' do
    end

    it 'should update file info of new file' do
    end
  end

  describe '#fetch_file_info' do
    before(:all) do
      @backup_file = create(:backup_file, :file, path: '/1.txt', parent_dir: '/')

      ## copy the example file to storage location for simulation
      @example_file = "#{Rails.root}/spec/factories/files/1.txt"
      FileUtils.mkdir_p(@backup_file.backup.storage_path)
      `cp -f #{@example_file} #{@backup_file.storage_path}`

      @backup_file.fetch_file_info
    end

    it 'should update #file_type field to be same as example file' do
      expect(@backup_file.file_type).to eq(MIME::Types.type_for(@example_file).first.to_s)
    end

    it 'should update #file_size field to be same as example file' do
      expect(@backup_file.file_size).to eq(File.size(@example_file))
    end
  end

  describe '#remove_file on before_destroy' do
    it 'should remove actual file from storage' do
      DatabaseCleaner.clean

      backup_file = create(:backup_file, :file, path: '/1.txt', parent_dir: '/')

      ## copy the example file to storage location for simulation
      FileUtils.mkdir_p(backup_file.backup.storage_path)
      `cp -f #{Rails.root}/spec/factories/files/1.txt #{backup_file.storage_path}`

      expect(File.exist?(backup_file.storage_path)).to eq(true)

      backup_file.destroy

      expect(File.exist?(backup_file.storage_path)).to eq(false)
    end
  end

  describe '#check_history on before_validation' do
    before(:each) do
      DatabaseCleaner.clean

      profile = create(:profile)

      @backup_v1 = create(:backup, profile: profile, version: 1)
      @backup_v2 = create(:backup, profile: profile, version: 2)

      @current_file = build(:backup_file, :file, backup: @backup_v2, file_size: 100)
    end

    it 'should set #status to "new" if no same file from last version' do
      @current_file.check_history

      expect(@current_file.status).to eq('new')
    end

    it 'should set #status to "changed" if file changed from last version' do
      create(:backup_file, :file, backup: @backup_v1, path: @current_file.path, file_size: 200)

      @current_file.check_history

      expect(@current_file.status).to eq('changed')
    end

    it 'should set #status to "unchanged" if file not changed from last version' do
      create(:backup_file, :file, backup: @backup_v1, path: @current_file.path, file_size: 100)

      @current_file.check_history

      expect(@current_file.status).to eq('unchanged')
    end
  end
end
