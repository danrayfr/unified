class AddCommentableToComments < ActiveRecord::Migration[7.0]
  def up
    add_reference :comments, :commentable, polymorphic: true, null: false
  end
end
