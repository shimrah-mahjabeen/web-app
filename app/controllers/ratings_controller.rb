class RatingsController < ApplicationController
  before_action :set_profile
  before_action :authenticate_user!

  def create
    @rating = @profile.ratings.find_or_initialize_by(user: current_user)
    @rating.score = rating_params[:score]

    if @rating.save
      redirect_to profiles_path, notice: "Rating was successfully created."
    else
      redirect_to profiles_path, alert: @rating.errors.full_messages.to_sentence
    end
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
  end

  def rating_params
    params.require(:rating).permit(:score)
  end
end
