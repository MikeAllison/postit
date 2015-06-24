module Flagable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flagable
  end

  def flag_exists?(user)
    self.flags.where("user_id = ? and flag = ?", user, true).exists?
  end
end
