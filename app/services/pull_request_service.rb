# app/services/pull_request_service.rb

require 'json'

class PullRequestService
  class << self
    def create(user, username, repo, title, head, base, body)
      post_request(user, username, repo + "/pulls", body_params(title, head, base, body))
    end

    def fetch_branches(user, username, repo)
      get_request(user, username, repo + "/branches")
    end

    def fetch_pull_requests(user, username, repo)
      get_request(user, username, repo + "/pulls")
    end

    private

    def get_request(user, username, endpoint)
      response = HTTParty.get(
        github_api_url(username, endpoint),
        headers: headers(user)
      )

      if response.success?
        JSON.parse(response.body)
      else
        puts "Error: #{response.dig('errors', 0, 'message')}"
        nil
      end
    end

    def post_request(user, username, endpoint, body)
      response = HTTParty.post(
        github_api_url(username, endpoint),
        headers: headers(user),
        body: body.to_json
      )

      if response.success?
        [true, JSON.parse(response.body)]
      else
        [false, response.dig('errors', 0, 'message')]
      end
    end


    def github_api_url(username, endpoint)
      "https://api.github.com/repos/#{username}/#{endpoint}"
    end

    def headers(user)
      {
        'Accept' => 'application/vnd.github+json',
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{github_api_key(user)}",
        'X-GitHub-Api-Version' => '2022-11-28'
      }
    end

    def github_api_key(user)
      user.github_token
    end

    def body_params(title, head, base, body)
      {
        title: title,
        head: head,
        base: base,
        body: body
      }
    end
  end
end
