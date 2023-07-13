# spec/controllers/search_controller_spec.rb
require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #index' do
    before do
      @user =  User.create!(user_name: "Test User", github_token: "abc123", email: "email@test.com", password: "password123")
      sign_in @user
      @profile1 = Profile.create!(github_username: 'User1', location: 'San Francisco', phone_number: '1234567890', user_id: @user.id)
      @profile2 = Profile.create!(github_username: 'User2', location: 'New York', phone_number: '0987654321', user_id: @user.id)
      @profile3 = Profile.create!(github_username: 'TestUser', location: 'Los Angeles', phone_number: '1112223333', user_id: @user.id)
    end

    it 'returns profiles based on the term' do
      get :index, params: { term: 'user' }
      parsed_response = JSON.parse(response.body)

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(parsed_response).to contain_exactly(
        "#{@profile1.id} - #{@profile1.github_username}",
        "#{@profile2.id} - #{@profile2.github_username}",
        "#{@profile3.id} - #{@profile3.github_username}"
      )
    end

    it 'is case insensitive' do
      get :index, params: { term: 'USER' }
      parsed_response = JSON.parse(response.body)

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(parsed_response).to contain_exactly(
        "#{@profile1.id} - #{@profile1.github_username}",
        "#{@profile2.id} - #{@profile2.github_username}",
        "#{@profile3.id} - #{@profile3.github_username}"
      )
    end

    it 'returns empty array if no matches are found' do
      get :index, params: { term: 'invalid_username' }
      parsed_response = JSON.parse(response.body)

      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(parsed_response).to be_empty
    end
  end
end
