# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def index
    term = params[:term].downcase
    profiles = Profile.where('lower(github_username) LIKE ? OR lower(location) LIKE ? OR phone_number LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%")
    suggestions = profiles.pluck(:github_username, :id).map { |github_username, id| "#{id} - #{github_username}" }
    render json: suggestions
  end
end
