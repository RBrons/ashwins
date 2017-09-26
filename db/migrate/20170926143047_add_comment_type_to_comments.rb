class AddCommentTypeToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :comment_type, :string
  end
end
