# spec/controllers/profiles_controller_spec.rb
require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  let(:user) { User.create(user_name: "testuser", github_token: "faketoken", email: "test@test.com", password: "test1234") }
  let(:profile) { Profile.create(location: "San Francisco", phone_number: "1234567890", user_id: user.id, github_username: "testuser") }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all profiles to @profiles and calculates average ratings" do
      profile1 = Profile.create(location: "San Francisco", phone_number: "1234567890", user_id: user.id, github_username: "user1")
      profile2 = Profile.create(location: "New York", phone_number: "0987654321", user_id: user.id, github_username: "user2")

      rating1 = Rating.create(score: 4, user_id: user.id, profile_id: profile1.id)
      rating2 = Rating.create(score: 3, user_id: user.id, profile_id: profile2.id)

      get :index

      expect(assigns(:profiles)).to match_array([profile1, profile2].sort_by(&:id))

      expect(assigns(:average_ratings)).to eq([4.0, 3.0])
      expect(assigns(:ratings)[profile1.id]).to be_a_new(Rating)
      expect(assigns(:ratings)[profile2.id]).to be_a_new(Rating)
    end
  end

  describe "GET #show" do
    it "assigns the requested profile and paginates the repos" do
      allow(RepoService).to receive(:fetch_all_repos).and_return([{"name" => "repo1"}, {"name" => "repo2"}, {"name" => "repo3"}])

      get :show, params: { id: profile.id }

      expect(assigns(:profile)).to eq(profile)
      expect(assigns(:repos)).to be_a(WillPaginate::Collection)
      expect(assigns(:repos).size).to eq(3)
      expect(assigns(:repos).current_page).to eq(1)
      expect(assigns(:repos).per_page).to eq(10)
    end
  end

  describe "GET #new" do
    it "assigns a new profile" do
      get :new

      expect(assigns(:profile)).to be_a_new(Profile)
    end
  end

  describe "GET #edit" do
    it "assigns the requested profile" do
      get :edit, params: { id: profile.id }

      expect(assigns(:profile)).to eq(profile)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new profile and redirects to the profile page with a success notice" do
        expect {
          allow(Profile).to receive(:create).and_return(double("profile", valid?: false))
          post :create, params:  { profile: { location: "New York", phone_number: "0987654321", user_id: user.id, github_username: "testuser" } }
        }.to change(Profile, :count).by(1)

        expect(response).to redirect_to(profile_url(assigns(:profile)))
        expect(flash[:notice]).to eq("Profile was successfully created.")
      end
    end

    context "with invalid parameters" do
      it "does not create a new profile and renders the new template with an unprocessable entity status" do
        expect {
          post :create, params: { profile: { location: nil, phone_number: nil, user_id: nil, github_username: nil } }
        }.not_to change(Profile, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid parameters" do
      it "updates the requested profile and redirects to the profile page with a success notice" do
        patch :update, params: { id: profile.id, profile: { location: "New York", phone_number: "0987654321" } }

        expect(profile.reload.location).to eq("New York")
        expect(profile.reload.phone_number).to eq("0987654321")
        expect(response).to redirect_to(profile_url(assigns(:profile)))
        expect(flash[:notice]).to eq("Profile was successfully updated.")
      end
    end

    context "with invalid parameters" do
      it "does not update the requested profile and redirects to the edit form with an unprocessable entity status" do
        patch :update, params: { id: profile.id, profile: { location: nil, phone_number: nil } }

        expect(profile.reload.location).not_to eq(nil)
        expect(profile.reload.phone_number).not_to eq(nil)
        expect(response).to redirect_to(profile_url(assigns(:profile)))
      end
    end

  end

  describe "DELETE #destroy" do
    it "destroys the requested profile and redirects to the profiles index with a success notice" do
      delete :destroy, params: { id: profile.id }

      expect(Profile.exists?(profile.id)).to be_falsey
      expect(response).to redirect_to(profiles_url)
      expect(flash[:notice]).to eq("Profile was successfully destroyed.")
    end
  end

  describe "GET #repo_details" do
    it "assigns the requested repo and fetches the pull requests if the current user owns the repo" do
      allow(RepoService).to receive(:fetch_repo).and_return({"name" => "test_repo", "owner" => {"login" => user.user_name}})
      allow(PullRequestService).to receive(:fetch_pull_requests).and_return(["pull_request1", "pull_request2"])

      get :repo_details, params: { username: user.user_name, repo: "test_repo" }

      expect(assigns(:repo)).to eq({"name" => "test_repo", "owner" => {"login" => user.user_name}})
      expect(assigns(:pull_requests)).to eq(["pull_request1", "pull_request2"])
    end
  end
end
