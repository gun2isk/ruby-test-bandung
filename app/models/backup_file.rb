class BackupFile < ApplicationRecord
  KINDS = %w{directory file}
  STATUSES = %w{new changed unchanged}

  belongs_to :backup

  validates :backup, :kind, :path, :parent_dir, :name, presence: true
  validates :kind, inclusion: {:in => KINDS}
  validates :status, inclusion: {:in => STATUSES}, :if => Proc.new { self.is_file? }

  before_destroy :remove_file
  before_validation :check_history, :if => Proc.new { self.is_file? }

  scope :new_files, -> { where(status: 'new') }
  scope :changed_files, -> { where(status: 'changed') }
  scope :unchanged_files, -> { where(status: 'unchanged') }

  def storage_path
    "#{Backup::BASE_STORAGE_PATH}/profile-#{self.backup.profile_id}/v#{self.backup.version}#{self.path}"
  end

  def is_directory?
    return true if self.kind.eql?('directory')
  end

  def is_file?
    return true if self.kind.eql?('file')
  end

  private

  def remove_file
    `rm -f #{storage_path}`
  end

  def check_history
    return true if self.is_directory?

    last_history = BackupFile.joins(:backup).where("backups.profile_id" => self.backup.profile_id, path: self.path).order("created_at DESC").first

    self.status = if last_history
      if last_history.file_size.eql?(self.file_size)
        'unchanged'
      else
        'changed'
      end
    else
      'new'
    end
  end

end
