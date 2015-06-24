module Flagable
  extend ActiveSupport::Concern

  included do
    has_many :flags, as: :flagable
  end

end
