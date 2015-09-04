class AddColumnToTweets < ActiveRecord::Migration
  def up
    #create column for user_id
    add_column :tweets, :user_id, :integer
    #delete a column called username
    remove_column :tweets, :user, :string
  end
  
  def down
    #remove column for user_id
    remove_column :tweets, :user_id, :integer
    #add a column called username
    add_column :tweets, :user, :string
  end
end
