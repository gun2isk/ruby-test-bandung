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
    @parent_path = File.dirname(params[:path]) if params[:path] and not params[:path].eql?('/')

    @backups = @profile.backups.order("version DESC")

    if @backups.count > 0
      @parent_dir_path = params[:path] || "/"

      @backup = if params[:backup_id]
        @backups.find(params[:backup_id])
      else
        @backups.first
      end

      @backup_files = @backup.files.where(parent_dir: @parent_dir_path).order(:kind)
    end
  end
  
  private

  def profile_params
    params.require(:profile).permit(:name, :backup_dirs, :backup_exclusion_dirs)
  end

  def find_profile
    @profile = current_user.profiles.find(params[:id])
  end
end
