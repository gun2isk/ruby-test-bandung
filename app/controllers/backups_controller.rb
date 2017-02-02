class BackupsController < ApplicationController
  before_action :authenticate_user!, :find_profile
  before_action :find_backup, only: [:destroy_file, :download_file]
  
  def run
    @profile.run_backup

    redirect_to @profile
  end

  def download_file
    @file = @backup.files.find(params[:file_id])

    send_file @file.storage_path
  end

  def destroy_file
    @file = @backup.files.find(params[:file_id])

    @file.destroy

    redirect_to :back
  end

  private

  def find_profile
    @profile = current_user.profiles.find(params[:profile_id])
  end

  def find_backup
    @backup = @profile.backups.find(params[:id])
  end

end
