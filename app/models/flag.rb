class Flag < ActiveRecord::Base

  belongs_to :flagger, foreign_key: 'user_id', class_name: 'User'
  belongs_to :flagable, polymorphic: true

  after_save :update_total_flags

  def update_total_flags
    id = self.flagable_id
    type = self.flagable_type

    if type == "Post"
      obj = Post.find(id)
    elsif type == "Comment"
      obj = Comment.find(id)
    end

    obj.total_flags = obj.flags.where(flag: true).count
    obj.save
  end

end
