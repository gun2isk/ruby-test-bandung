class CreateBackupFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :backup_files do |t|
      t.references :backup, foreign_key: true
      t.string :kind
      t.string :parent_dir
      t.string :path
      t.string :name
      t.string :file_type
      t.integer :file_size
      t.datetime :last_modified

      t.timestamps
    end
  end
end
