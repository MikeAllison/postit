module Flagable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flagable

    scope :flagged_desc, -> { flagged.order(total_flags: :desc) }

    after_initialize :initialize_hidden_attr, if: :new_record?
    after_initialize :initialize_total_flags, if: :new_record?

    def self.flagged
      ids_with_flags = Flag.select(:flagable_id)
                            .distinct
                            .where(flagable_type: self.to_s, flag: true)

      self.where(id: ids_with_flags)
    end
  end

  def flagged_by?(user)
    self.flags.find_by('user_id = ? and flag = ?', user.id, true).present?
  end

  def flagged?
    return true if self.flags.find_by(flag: true)
    false
  end

  def reset_total_flags
    self.total_flags = 0
    self.save
  end

  private

  def initialize_total_flags
    self.total_flags = 0
  end

  def initialize_hidden_attr
    self.hidden = false
  end
end
