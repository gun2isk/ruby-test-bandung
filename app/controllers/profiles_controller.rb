class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_profile, only: [:show, :destroy]

  def index
    @profiles = current_user.profiles
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = current_user.profiles.new(profile_params)

    if @profile.save
      redirect_to @profile
    else
      render action: :new
    end
  end

  def show
    
  end

  def destroy
    @profile.destroy

    redirect_to profiles_url
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :backup_dirs, :backup_exclusion_dirs)
  end

  def find_profile
    @profile = current_user.profiles.find(params[:id])
  end
end
