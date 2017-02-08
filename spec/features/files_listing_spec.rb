require 'rails_helper'

RSpec.describe 'Backup Files listing' do
  let(:user) { create(:user) }
  let(:profile)  { create(:profile, backup_dirs: "#{Rails.root}/public/source-examples1/", user: user) }
  let(:backup) { profile.backups.first }

  before(:each) do
    DatabaseCleaner.clean

    login_as user

    visit profile_path(profile)
  end

  context 'params[:path] is not set' do
    it 'should display directories and files under "root" path' do
      expect(page).to have_content("child-dir-example")
      expect(page).to have_content("1.txt")
    end
  end

  context 'params[:path] is set' do
    it 'should display directories and files under specific params[:path] path' do
      click_link('child-dir-example')

      expect(page).to have_content("1-1.txt")
    end
  end
end