require 'rails_helper'

RSpec.describe 'Displaying total storage usage' do
  let(:user) { create(:user) }

  it 'should display total storage per User on index page' do
    DatabaseCleaner.clean

    login_as user

    3.times { create(:profile, user: user) }

    visit profiles_path

    expect(page).to have_content("Total Storage Usage : #{number_to_human_size(user.profiles.sum(:storage_size))}")
  end
end