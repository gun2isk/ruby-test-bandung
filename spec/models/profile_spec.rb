require 'rails_helper'

RSpec.describe Profile, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:backups).dependent(:destroy) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:backup_dirs) }

  describe '#set_dirs on before_validation' do
    let(:profile) { profile = build(:profile) }

    it 'should set #backup_dirs to be Array' do
      backup_dirs = "#{Rails.root}/public/source-examples1\r\n#{Rails.root}/public/source-examples2"
      profile.backup_dirs = backup_dirs
      profile.validate

      expect(profile.backup_dirs).to eq(backup_dirs.split("\r\n"))
    end

    it 'should set #backup_exclusion_dirs to be Array' do
      exclusion_dirs = "/source-examples1\r\n/source-examples2"
      profile.backup_exclusion_dirs = exclusion_dirs
      profile.validate

      expect(profile.backup_exclusion_dirs).to eq(exclusion_dirs.split("\r\n"))
    end
  end

  describe '#update_storage_size' do
    it 'should set Profile#storage_size to total size of files' do
      Profile.skip_callback(:create)

      profile = build(:profile, storage_size: 0)
      backup = build(:backup, profile: profile)

      files = 3.times.map do
        create(:backup_file, backup: backup, kind: 'file', file_size: rand(1000))
      end

      profile.update_storage_size

      expect(profile.storage_size).to eq(files.sum(&:file_size))
    end
  end
end
