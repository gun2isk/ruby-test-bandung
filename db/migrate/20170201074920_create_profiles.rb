class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.text :backup_dirs
      t.text :backup_exclusion_dirs
      t.datetime :last_backup

      t.timestamps
    end
  end
end
