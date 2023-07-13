class ProfilesController < ApplicationController
  before_action :set_profile, only: %i( show edit update destroy )
  before_action :authorize_user, only: %i( edit update destroy )
  before_action :authorize_github_user, only: %i( new show )

  def index
    @profiles = Profile.includes(:ratings).all.paginate(page: params[:page], per_page: 10)
    @average_ratings = @profiles.map do |profile|
      (profile.ratings.average(:score) || 0).to_f.round(2)
    end

    @ratings = {}
    @profiles.each do |profile|
      @ratings[profile.id] = profile.ratings.build
    end
  end

  def show
    repos = RepoService.fetch_all_repos(@profile.github_username, current_user)
    @repos = WillPaginate::Collection.create(params[:page] || 1, 10, repos.size) do |pager|
      pager.replace(repos[pager.offset, pager.per_page])
    end
  end

  def new
    @profile = Profile.new
  end

  def edit
  end

  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to profile_url(@profile), notice: "Profile was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_url(@profile), notice: "Profile was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
    end
  end

  def repo_details
    @repo = RepoService.fetch_repo(params[:username], params[:repo], current_user)
    @pull_requests = PullRequestService.fetch_pull_requests(current_user, current_user.user_name, params[:repo]) if current_user.user_name == @repo['owner']['login']
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def authorize_github_user
    unless current_user.user_name.present?
      redirect_to profiles_url, alert: 'You are not authorized to perform this action. Make sure you are signed in using Github'
    end
  end

  def authorize_user
    unless @profile.user == current_user
      redirect_to profiles_url, alert: 'You are not authorized to perform this action. Make sure you are signed in using Github'
    end
  end

  def profile_params
    params.require(:profile).permit(:location, :phone_number, :image, :user_id, :github_username, skills: [])
  end
end
