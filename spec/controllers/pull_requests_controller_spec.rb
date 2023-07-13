# # spec/controllers/pull_requests_controller_spec.rb

# require 'rails_helper'

# RSpec.describe PullRequestsController, type: :controller do
#   let(:user) { User.create!(user_name: 'testuser', github_token: 'faketoken', email: "test@test.com", password: "test1234") }
#   let(:valid_attributes) {
#     { username: 'testuser', repo: 'testrepo', title: 'test title', head: 'testhead', base: 'testbase', body: 'testbody' }
#   }
#   let(:invalid_attributes) {
#     { username: nil, repo: nil, title: nil, head: nil, base: nil, body: nil }
#   }

#   before do
#     sign_in user
#   end

#   describe "GET #new" do
#     it "returns a success response" do
#       stub_request(:get, "https://api.github.com/repos/testuser/testrepo/branches")
#         .to_return(body: [].to_json, status: 200)

#       get :new, params: { repo: 'testrepo' }
#       expect(response).to be_successful
#     end
#   end

#   describe "POST #create" do
#     context "with valid parameters" do
#       it "creates a new pull request" do
#         stub_request(:post, "https://api.github.com/repos/testuser/testrepo/pulls")
#           .with(body: valid_attributes.to_json)
#           .to_return(body: { id: 1 }.to_json, status: 201)

#         post :create, params: { pull_request: valid_attributes }
#         expect(response).to redirect_to(repo_details_path(username:  user.user_name, repo: valid_attributes[:repo]))
#       end
#     end

#     context "with invalid parameters" do
#       it "does not create a new pull request and redirects to new pull request path" do
#         post :create, params: { pull_request: invalid_attributes }
#         expect(response).to redirect_to(new_pull_request_path(repo: invalid_attributes[:repo]))
#       end
#     end
#   end
# end


require 'rails_helper'

RSpec.describe PullRequestsController, type: :controller do
  describe "GET #new" do
    let(:user) { User.create(user_name: "Test User", github_token: "abc123", email: "email@test.com", password: "password123") }
    let(:branches) { [{"name" => "master"}, {"name" => "development"}] }
    let(:repo) { "test_repo" }

    before do
      allow(PullRequestService).to receive(:fetch_branches).and_return(branches)
      sign_in user
      get :new, params: { repo: repo }
    end

    it "assigns a new pull request to @pull_request" do
      expect(assigns(:pull_request)).to be_a_new(PullRequest)
    end

    it "assigns repo to @repo" do
      expect(assigns(:repo)).to eq(repo)
    end

    it "assigns branches to @branches" do
      expect(assigns(:branches)).to eq(branches)
    end
  end

  describe "POST #create" do
    let(:user) { User.create(user_name: "Test User", github_token: "abc123", email: "email@test.com", password: "password123") }
    let(:pull_request_params) { { username: "Test User", repo: "test_repo", title: "Test PR", head: "master", base: "development", body: "PR Body" } }
    let(:branches) { [{"name" => "master"}, {"name" => "development"}] }

    before do
      allow(PullRequestService).to receive(:fetch_branches).and_return(branches)
      sign_in user
    end

    context "when valid" do
      before do
        allow(PullRequestService).to receive(:create).and_return([true, {}])
        post :create, params: { pull_request: pull_request_params }
      end

      it "redirects to repo details with a success notice" do
        expect(response).to redirect_to(repo_details_path(username:  user.user_name, repo: pull_request_params[:repo]))
        expect(flash[:notice]).to eq("Pull request created successfully!")
      end
    end

    context "when invalid" do
      before do
        allow(PullRequestService).to receive(:create).and_return([false, "Error message"])
        post :create, params: { pull_request: pull_request_params }
      end

      it "redirects to new pull request with an error alert" do
        expect(response).to redirect_to(new_pull_request_path(repo: pull_request_params[:repo]))
        expect(flash[:alert]).to eq("Error creating pull request: Error message")
      end
    end
  end
end
