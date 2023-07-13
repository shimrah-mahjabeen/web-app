class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found(exception)
    render json: { error: I18n.t('record_not_found', record: exception.model) }, status: :not_found
  end

  def search
    term = params[:term].downcase
    users = User.where('lower(name) LIKE ? OR lower(email) LIKE ?', "%#{term}%", "%#{term}%")
    profiles = Profile.where('lower(user_name) LIKE ? OR lower(location) LIKE ? OR phone_number LIKE ?', "%#{term}%", "%#{term}%", "%#{term}%")
    suggestions = users.pluck(:name, :email) + profiles.pluck(:user_name, :location, :phone_number)
    suggestions.flatten!
    render json: suggestions
  end

end
