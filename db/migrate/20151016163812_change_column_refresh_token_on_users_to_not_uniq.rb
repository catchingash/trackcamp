class ChangeColumnRefreshTokenOnUsersToNotUniq < ActiveRecord::Migration
  def change
    remove_index :users, column: :refresh_token
  end
end
