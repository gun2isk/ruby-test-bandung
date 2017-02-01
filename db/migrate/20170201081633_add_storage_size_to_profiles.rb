class AddStorageSizeToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :storage_size, :integer, default: 0
  end
end
