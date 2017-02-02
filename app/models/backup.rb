require 'mime/types'

class Backup < ApplicationRecord
  BASE_STORAGE_PATH  = "#{Rails.root}/public/backups"

  belongs_to :profile

  has_many :files, class_name: 'BackupFile', dependent: :destroy

  validates :profile, :version, :backup_time, presence: true
  validates :version, uniqueness: {scope: :profile_id}

  before_destroy :remove_storage

  def storage_path
    @storage_path ||= "#{BASE_STORAGE_PATH}/profile-#{self.profile_id}/v#{self.version}/"
  end

  def run_sync # copy the specified files to storage location using Rsync linux command
    ## make sure storage directory is there
    FileUtils.mkdir_p(self.storage_path)

    exclusion_command = self.profile.backup_exclusion_dirs.map {|dir| "--exclude #{dir}" }.join(' ')

    # run rsync command for each listed backup directory
    self.profile.backup_dirs.each do |backup_dir|
      `rsync -a #{exclusion_command} #{backup_dir} #{self.storage_path}`
    end
  end

  def run
    self.run_sync # run files sync

    ## Store the backed up files to database
    paths = Dir.glob("#{self.storage_path}**/*")

    paths.each do |path|
      backup_file = self.files.new
      backup_file.kind = File.directory?(path) ? 'directory' : 'file'
      backup_file.path = path.gsub(self.storage_path, '/')
      backup_file.parent_dir = File.dirname(backup_file.path)
      backup_file.name = File.basename(path)

      if backup_file.is_file?
        backup_file.file_type = MIME::Types.type_for(path).first.to_s
        backup_file.file_size = File.size(path)
        backup_file.last_modified = File.mtime(path)
      end

      backup_file.save
    end

    ## Update storage size of the profile
    self.profile.update_storage_size

    ## Update last_backup of Profile
    self.profile.update_attribute(:last_backup, Time.now)

    ## Update attrs after backup
    self.update_backup_attrs
  end

  def update_backup_attrs
    self.file_count = self.files.count
    self.new_file_count = self.files.new_files.count
    self.modified_file_count = self.files.changed_files.count
    self.save
  end

  def version_name
    "Version #{self.version} - #{self.backup_time.strftime("%Y-%m-%d %H:%M")}"
  end

  private

  def remove_storage
    `rm -rf #{self.storage_path}`
  end

end
