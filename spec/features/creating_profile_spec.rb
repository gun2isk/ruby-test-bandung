require 'rails_helper'

RSpec.describe 'Profile creation process' do
  before(:each) do
    DatabaseCleaner.clean
    
    user = create(:user)
    login_as(user)

    visit '/'
    click_on 'Create new Profile'
  end

  context 'fill form correctly' do
    it 'creates new profile' do
      fill_in 'profile_name', with: 'Profile 1'
      fill_in 'profile_backup_dirs', with: "#{Rails.root}/public/source-examples1"
      fill_in 'profile_backup_exclusion_dirs', with: '/exclusion-dir-1'
      click_button 'Create Profile'

      expect(page).to have_current_path(profile_path(Profile.order('created_at DESC').first))
    end
  end

  context 'fill form incorrectly' do
    it "won't create profile without #name" do
      fill_in 'profile_name', with: ''
      click_button 'Create Profile'

      expect(page).to have_selector('form#new_profile')
      expect(page).to have_content("name can't be blank")
    end

    it "won't create profile without #backup_dirs" do
      fill_in 'profile_name', with: 'Profile 1'
      fill_in 'profile_backup_dirs', with: ''
      click_button 'Create Profile'

      expect(page).to have_selector('form#new_profile')
      expect(page).to have_content("backup_dirs can't be blank")
    end
  end

end