module Flagable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flagable

    default_scope { where(hidden: false) }
    scope :flagged, -> { joins(:flags).where('flag = ?', true).distinct.order(flags_count: :desc) }
  end

  def user_flagged?(user)
    self.flags.find_by("user_id = ? and flag = ?", user, true).present?
  end

  def flagged?
    self.flags.find_by(flag: true).present?
  end

  private

    def initialize_flags_count
      self.flags_count = 0
    end

    def initialize_hidden_attr
      self.hidden = false
    end

end
