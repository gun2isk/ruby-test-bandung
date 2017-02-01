class CreateBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :backups do |t|
      t.references :profile, foreign_key: true
      t.integer :version, default: 0
      t.datetime :backup_time
      t.integer :file_count, default: 0
      t.integer :new_file_count, default: 0
      t.integer :modified_file_count, default: 0

      t.timestamps
    end
  end
end
