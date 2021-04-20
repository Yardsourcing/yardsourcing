require 'rails_helper'

RSpec.describe 'Search Page' do
  describe 'happy path' do
    before :each do
      user = User.create!(id:1, uid: '123545', username: 'Dominic Padula', email:'thisemail@gmail.com' )
      omniauth_response = stub_omniauth_happy('123545', 'Dominic Padula', 'thisemail@gmail.com')
      @user_1 = User.from_omniauth(omniauth_response)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    end

    it 'displays text and form' do
      VCR.use_cassette('all_purposes') do
        visit search_index_path
        expect(page).to have_content("Find your dream yard:")
        expect(page).to have_content("Where will you yard?")
        expect(page).to have_content("How will you spend your time yarding?")
        expect(page).to have_content('Pet Rental')
        expect(page).to have_content('Party Rental')
        expect(page).to have_content('Hobby Rental')
      end
    end

    it 'displays form with location prefilled in' do
      VCR.use_cassette('all_purposes') do
        visit search_index_path
        expect(page).to have_field('location')
        expect(page).to have_unchecked_field('purposes_1')
        expect(page).to have_unchecked_field('purposes_2')
        expect(page).to have_unchecked_field('purposes_3')
        expect(page).to have_button('Yard Me')
      end
    end

    it "when filled in the form brings you to the yards/search" do
      VCR.use_cassette('all_purposes') do
        VCR.use_cassette('create_search') do
          visit search_index_path
          fill_in :location, with: '46311'
          check 'purposes_1'
          click_button 'Yard Me'
        end
      end
    end
  end
end
