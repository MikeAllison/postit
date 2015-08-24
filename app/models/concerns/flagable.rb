module Flagable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flagable

    default_scope { where(hidden: false) }
    scope :flagged, -> { where('total_flags >= ?', 1) }
    scope :flagged_desc, -> { flagged.order(total_flags: :desc) }

    after_initialize :initialize_hidden_attr, if: :new_record?
    after_initialize :initialize_total_flags, if: :new_record?
  end

  def flagged_by?(user)
    self.flags.find_by("user_id = ? and flag = ?", user, true).present?
  end

  def flagged?
    self.total_flags >= 1
  end

  private

    def initialize_total_flags
      self.total_flags = 0
    end

    def initialize_hidden_attr
      self.hidden = false
    end

end
