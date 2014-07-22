class Likes < ActiveRecord::Migration
  def up
    create_table :likes do |t|
      t.integer :like
      t.string :message_id
    end
  end

  def down
    drop_table :likes
  end
end