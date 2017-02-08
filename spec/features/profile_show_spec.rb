require 'rails_helper'

RSpec.describe 'Profile show page' do
  let(:user) { create(:user) }
  let(:profile)  { create(:profile, user: user) }
  let(:backup) { profile.backups.first }

  before(:each) do
    DatabaseCleaner.clean

    login_as user

    visit profile_path(profile)
  end

  it 'should display profile information' do
    expect(page).to have_content("Profile name : #{profile.name}")
    expect(page).to have_content("Display Charts Statistics")
  end

  it 'should have version history selection area' do
    expect(page).to have_content('Select the backup histories :')
    expect(page).to have_selector('select#backup_version')
    expect(page).to have_select('backup_version', options: [backup.version_name])
  end

  it 'should have backup button' do
    expect(page).to have_link('Run New Backup')
  end

  it 'shoud have backup details' do
    expect(page).to have_content("Version : #{backup.version}")
    expect(page).to have_content("Date : #{backup.created_at.strftime("%Y-%m-%d")}")
    expect(page).to have_content("Time : #{backup.created_at.strftime("%H:%M")}")
    expect(page).to have_content("New Files : #{backup.new_file_count}")
    expect(page).to have_content("Modified Files : #{backup.modified_file_count}")    
    expect(page).to have_link('Display New and Modified Files')
  end
  
end