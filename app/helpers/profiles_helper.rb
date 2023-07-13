module ProfilesHelper
  def profile_link_path(user)
    if user.profile
      profile_path(user.profile)
    else
      new_profile_path
    end
  end
end
