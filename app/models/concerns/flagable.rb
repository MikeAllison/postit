module Flagable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flagable
  end

  def user_flagged?(user)
    self.flags.find_by("user_id = ? and flag = ?", user, true).present?
  end

  def flagged?
    self.flags.find_by(flag: true).present?
  end
end
