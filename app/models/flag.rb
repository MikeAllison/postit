class Flag < ActiveRecord::Base
  belongs_to :flagger, foreign_key: 'user_id', class_name: 'User'
  belongs_to :flagable, polymorphic: true

  before_save :update_total_flags

  def update_total_flags
    type = self.flagable_type

    if type == 'Post'
      obj = Post.find(self.flagable_id)
    elsif type == 'Comment'
      obj = Comment.find(self.flagable_id)
    end

    obj.total_flags = obj.flags.where(flag: true).count
    self.flag == true ? obj.total_flags += 1 : obj.total_flags -= 1
    obj.save
  end

  def opposite_exists?(submitted_flag)
    self.persisted? && self.flag == !submitted_flag
  end
end
