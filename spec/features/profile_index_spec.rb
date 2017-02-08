require 'rails_helper'

RSpec.describe 'Profiles list page' do
  let(:user) { create(:user) }

  before(:each) do
    DatabaseCleaner.clean

    login_as user
  end

  context 'there are some profiles created' do
    it 'should lists the profiles names' do
      profiles = 3.times.map { create(:profile, user: user) }

      visit profiles_path

      profiles.each do |profile|
        expect(page).to have_content(profile.name)
      end
    end
  end

end