class AddStatusToBackupFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :backup_files, :status, :string

    add_index :backup_files, :status
  end
end
