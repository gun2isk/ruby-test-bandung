require 'rails_helper'

RSpec.describe 'Checking file history and Restoring file' do
  let(:user) { create(:user) }
  let(:profile)  { create(:profile, backup_dirs: "#{Rails.root}/public/source-examples1/", user: user) }
  let(:backup) { profile.backups.first }
  let(:backup_file) { backup.files.where(kind: 'file').first }

  before(:each) do
    DatabaseCleaner.clean

    login_as user

    visit profile_path(profile)
  end

  it 'should open history page when click "Check History" button' do
    within("tr#backup-file-#{backup_file.id}") do
      click_link 'Check History'
    end

    expect(page).to have_current_path(file_history_profile_backup_path(profile, backup, file_id: backup_file.id))
  end

  context 'in history page of file' do
    it 'should display files with same path from other versions' do
      ## simulate 3 times more backup
      3.times { profile.run_backup }
      
      visit file_history_profile_backup_path(profile, backup, file_id: backup_file.id)
      
      history_files = BackupFile.joins(:backup).where("backups.profile_id" => backup_file.backup.profile_id, path: backup_file.path).order("backup_files.created_at DESC")

      history_files.each do |history_file|
        next if history_file.eql?(backup_file)

        selector = "tr#file-history-#{history_file.id}"

        expect(history_file.path).to eq(backup_file.path)
        expect(page).to have_selector(selector)
        expect(page.find(selector)).to have_content(history_file.name)
        expect(page.find(selector)).to have_content(history_file.backup.version_name)
      end
    end

    it 'should restore file to specific version when click on Restore button' do
      ## simulate 3 times more backup
      3.times { profile.run_backup }
      
      visit file_history_profile_backup_path(profile, backup, file_id: backup_file.id)

      restore_file = profile.backups.order('version DESC').first.files.where(path: backup_file.path).first

      ## simulate change on the restore file, so size will be different with original file
      File.write(restore_file.storage_path, Faker::Lorem.sentence(1000))

      restore_file.fetch_file_info
      restore_file.save

      within "tr#file-history-#{restore_file.id}" do
        click_link 'Restore'
      end

      ## check the file size should be changed
      expect(page.find('.well#file-info')).to have_content("Size : #{number_to_human_size(restore_file.file_size)}")
    end
  end
end