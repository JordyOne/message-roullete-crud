class ChangeLike < ActiveRecord::Migration
  def change
    rename_column :likes, :like, :like_num

  end
end