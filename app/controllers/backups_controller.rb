class BackupsController < ApplicationController
  before_action :authenticate_user!, :find_profile
  before_action :find_backup, except: [:run]
  
  def show
    @new_files = @backup.files.new_files.order('created_at DESC')
    @changed_files = @backup.files.changed_files.order('created_at DESC')
  end

  def run
    @profile.run_backup

    redirect_to @profile
  end

  def download_file
    @file = @backup.files.find(params[:file_id])

    send_file @file.storage_path
  end

  def file_history
    @file = @backup.files.find(params[:file_id])

    @history_files = BackupFile.joins(:backup).where("backups.profile_id" => @file.backup.profile_id, path: @file.path).order("backup_files.created_at DESC").includes(:backup)
  end

  def restore_file
    @file = @backup.files.find(params[:file_id])

    @file.restore_file(params[:restore_id])

    redirect_back(fallback_location: root_path)
  end

  def destroy_file
    @file = @backup.files.find(params[:file_id])

    @file.destroy

    redirect_back(fallback_location: root_path)
  end

  private

  def find_profile
    @profile = current_user.profiles.find(params[:profile_id])
  end

  def find_backup
    @backup = @profile.backups.find(params[:id])
  end

end
