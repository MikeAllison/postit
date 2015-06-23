class Flag < ActiveRecord::Base

  belongs_to :flagger, foreign_key: 'user_id', class_name: 'User'
  belongs_to :flagable, polymorphic: true, counter_cache: :flags_count

end
