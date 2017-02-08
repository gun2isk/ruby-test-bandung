require 'rails_helper'

RSpec.describe 'Deleting file from specific backup' do
  let(:user) { create(:user) }
  let(:profile)  { create(:profile, backup_dirs: "#{Rails.root}/public/source-examples1/", user: user) }
  let(:backup) { profile.backups.first }

  before(:each) do
    DatabaseCleaner.clean

    login_as user

    visit profile_path(profile)
  end

  it 'should delete file when delete button clicked' do
    backup_file = backup.files.where(kind: 'file').first

    within("tr#backup-file-#{backup_file.id}") do
      click_link 'Delete'
    end

    expect(page).to_not have_selector("tr#backup-file-#{backup_file.id}")
  end
end