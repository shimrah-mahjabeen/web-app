class PullRequestsController < ApplicationController
  def new
    @pull_request = PullRequest.new
    @repo = params['repo']
    @branches = PullRequestService.fetch_branches(current_user, current_user.user_name, @repo)
  end

  def create
    @pull_request = PullRequest.new(pull_request_params)
    if @pull_request.valid?
      success, response = PullRequestService.create(
        current_user,
        @pull_request.username,
        @pull_request.repo,
        @pull_request.title,
        @pull_request.head,
        @pull_request.base,
        @pull_request.body
      )

      if success
        set_branches_and_repo
        redirect_to repo_details_path(username:  current_user.user_name, repo: @repo), notice: "Pull request created successfully!"
      else
        set_branches_and_repo
        redirect_to new_pull_request_path(repo: @repo), alert: "Error creating pull request: #{response}"
      end
    else
      set_branches_and_repo
      redirect_to new_pull_request_path(repo: @repo)
    end
  end

  private

  def pull_request_params
    params.require(:pull_request).permit(:username, :repo, :title, :head, :base, :body)
  end

  def set_branches_and_repo
    @repo = @pull_request.repo
    @branches = PullRequestService.fetch_branches(current_user, current_user.user_name, @repo)
  end
end
