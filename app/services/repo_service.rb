# app/services/repo_service.rb

require 'json'

class RepoService
  class << self
    def fetch_repo(username, repo, user)
      request("https://api.github.com/repos/#{username}/#{repo}", user)
    end

    def fetch_all_repos(username, user)
      request("https://api.github.com/users/#{username}/repos", user)
    end

    private

    def request(url, user)
      response = HTTParty.get(url, headers: headers(user))

      if response.success?
        JSON.parse(response.body)
      else
        puts "Error: #{response.code}"
        nil
      end
    end

    def headers(user)
      {
        'Accept' => 'application/vnd.github+json',
        'Authorization' => "Bearer #{github_api_key(user)}",
        'X-GitHub-Api-Version' => '2022-11-28'
      }
    end

    def github_api_key(user)
      user.github_token
    end
  end
end
