require 'rails_helper'

RSpec.describe 'Downloading backup file' do
  let(:user) { create(:user) }
  let(:profile)  { create(:profile, backup_dirs: "#{Rails.root}/public/source-examples1/", user: user) }
  let(:backup) { profile.backups.first }

  before(:each) do
    DatabaseCleaner.clean

    login_as user

    visit profile_path(profile)
  end

  it 'should download file when Download button clicked' do
    backup_file = backup.files.where(kind: 'file').first

    within("tr#backup-file-#{backup_file.id}") do
      click_link 'Download'
    end

    expect(page.response_headers['Content-Type']).to eq(backup_file.file_type)
  end
end