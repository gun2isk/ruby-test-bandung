class AddGidAndUidToBackupFiles < ActiveRecord::Migration[5.0]
  def change
    add_column :backup_files, :gid, :string
    add_column :backup_files, :uid, :string
  end
end
