class BackupsController < ApplicationController
  before_action :authenticate_user!, :find_profile
  
  def run
    @profile.run_backup

    redirect_to @profile
  end

  private

  def find_profile
    @profile = current_user.profiles.find(params[:profile_id])
  end

end
