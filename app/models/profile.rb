class Profile < ApplicationRecord
  
  serialize :backup_dirs
  serialize :backup_exclusion_dirs

  belongs_to :user

  has_many :backups, dependent: :destroy

  validates :user, :name, :backup_dirs, presence: true
  validates :name, uniqueness: {scope: :user_id}

  before_validation :set_dirs
  after_create :run_backup

  def run_backup
    backup = self.backups.create(version: self.backups.count + 1, backup_time: Time.now)

    backup.run
  end

  def update_storage_size
    self.update_attribute(:storage_size, BackupFile.joins(:backup).where("backups.profile_id = ?", self.id).sum(:file_size))
  end

  def file_types_chart_series
    file_types = BackupFile.joins(:backup).where("backups.profile_id" => self.id).pluck(:file_type).delete_if {|ft| ft.blank? }

    file_types.uniq.map do |file_type|
      percentage = (file_types.count(file_type) / file_types.count.to_f) * 100

      [file_type, sprintf("%0.2f", percentage).to_f]
    end
  end

  def size_ranges_chart_series
    files_count = BackupFile.joins(:backup).where("backups.profile_id = ? AND kind = ?", self.id, 'file').count
    
    ['Less than 1 MB', 'Between 1 MB and 10 MB', 'Between 10 MB and 25 MB', 'Between 25 MB and 50 MB', 'More than 50 MB'].map do |range|
      conditions = case range
      when 'Less than 1 MB'
        "file_size < #{1 * (1024 * 1024)}"
      when 'Between 1 MB and 10 MB'
        "file_size BETWEEN #{1 * (1024 * 1024)} AND #{10 * (1024 * 1024)}"
      when 'Between 10 MB and 25 MB'
        "file_size BETWEEN #{10 * (1024 * 1024)} AND #{25 * (1024 * 1024)}" 
      when 'Between 25 MB and 50 MB'
        "file_size BETWEEN #{25 * (1024 * 1024)} AND #{50 * (1024 * 1024)}" 
      when 'More than 50 MB'
        "file_size > #{50 * (1024 * 1024)}"
      end

      count = BackupFile.joins(:backup).where("backups.profile_id = ? AND kind = ?", self.id, 'file').where(conditions).count
      percentage = (count / files_count.to_f) * 100

      [range, sprintf("%0.2f", percentage).to_f]
    end
  end

  private

  def set_dirs
    self.backup_dirs = self.backup_dirs.to_s.split("\r\n") if not self.backup_dirs.is_a?(Array)
    self.backup_exclusion_dirs = self.backup_exclusion_dirs.to_s.split("\r\n") if not self.backup_exclusion_dirs.is_a?(Array)

    true
  end

end
