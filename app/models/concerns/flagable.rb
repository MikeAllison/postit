module Flagable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flagable
  end

  def user_flagged?(user)
    self.flags.where("user_id = ? and flag = ?", user, true).exists?
  end

  def flagged?
    self.flags.where(flag: true).any?
  end
end
