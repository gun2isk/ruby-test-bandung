require 'rails_helper'

RSpec.describe 'Profile show page' do
  let(:user) { create(:user) }
  let(:profile)  { create(:profile, user: user) }

  before(:each) do
    DatabaseCleaner.clean

    login_as user

    visit charts_profile_path(profile)
  end

  it 'should display profile name' do
    expect(page).to have_content("Profile name : #{profile.name}")
  end
end