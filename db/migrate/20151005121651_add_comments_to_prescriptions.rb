class AddCommentsToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :comments, :text
  end
end
