class Profile < ApplicationRecord
  
  serialize :backup_dirs
  serialize :backup_exclusion_dirs

  belongs_to :user

  has_many :backups, dependent: :destroy

  validates :user, :name, :backup_dirs, presence: true
  validates :name, uniqueness: {scope: :user_id}

  before_validation :set_dirs

  def set_dirs
    self.backup_dirs = self.backup_dirs.to_s.split("\r\n") if not self.backup_dirs.is_a?(Array)
    self.backup_exclusion_dirs = self.backup_exclusion_dirs.to_s.split("\r\n") if not self.backup_exclusion_dirs.is_a?(Array)

    true
  end

  def run_backup
    backup = self.backups.create(version: self.backups.count + 1, backup_time: Time.now)

    backup.run
  end

  def update_storage_size
    self.update_attribute(:storage_size, BackupFile.joins(:backup).where("backups.profile_id = ?", self.id).sum(:file_size))
  end

end
