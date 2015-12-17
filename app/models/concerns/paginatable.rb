module Paginatable
  extend ActiveSupport::Concern

  included do
    class_attribute :items_per_page
    class_attribute :links_per_page
  end

  module ClassMethods
    def set_items_per_page(num_items)
      self.items_per_page = num_items
    end

    def set_links_per_page(num_links)
      self.links_per_page = num_links
    end

    def total_pages
      total_pages = self.count / items_per_page
      total_pages += 1 if self.count % items_per_page > 0
      total_pages
    end

    def paginate(page)
      (page ||= 1).to_i
      page = 1 if page < 1
      page = total_pages if page > total_pages

      calculated_offset = (page - 1) * items_per_page
      # Fix for Postgres not liking negative offsets
      calculated_offset = 0 if calculated_offset < 0

      self.limit(items_per_page).offset(calculated_offset)
    end

  end
end
