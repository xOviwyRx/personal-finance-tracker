class RenameJwtDenylistsToJwtDenylist < ActiveRecord::Migration[7.1]
  def change
    rename_table :jwt_denylists, :jwt_denylist
  end
end
