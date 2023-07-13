require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:user) { User.create!(user_name: "Test User", github_token: "abc123", email: "email@test.com", password: "password123") }
  let(:profile) { Profile.create!(user: user) }

  before do
    # Simulate a logged-in user
    sign_in user
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new rating' do
        expect {
          post :create, params: { profile_id: profile.id, rating: { score: 5 } }
        }.to change(Rating, :count).by(1)
      end

      it 'redirects to the profiles list' do
        post :create, params: { profile_id: profile.id, rating: { score: 5 } }
        expect(response).to redirect_to(profiles_path)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new rating' do
        expect {
          post :create, params: { profile_id: profile.id, rating: { score: nil } }
        }.to_not change(Rating, :count)
      end

      it 'redirects to the profiles list' do
        post :create, params: { profile_id: profile.id, rating: { score: nil } }
        expect(response).to redirect_to(profiles_path)
      end
    end
  end
end
