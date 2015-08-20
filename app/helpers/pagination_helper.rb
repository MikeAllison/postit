module PaginationHelper

  class Paginator
    attr_reader :links_per_page, :total_pages
    attr_accessor :current_page

    def initialize(obj)
      @obj = obj
      @items_per_page = obj.items_per_page
      @links_per_page = obj.links_per_page
      @total_pages = obj.total_pages
    end

    def current_page
      current_page = (@current_page ||= 1).to_i
      current_page = 1 if current_page < 1
      current_page = total_pages if current_page > total_pages
      current_page
    end

    def previous_page
      current_page.pred
    end

    def next_page
      current_page.next
    end

    def first_page?
      current_page == 1
    end

    def last_page?
      current_page == total_pages
    end

    def current_range_first_page
      (((current_page - 1) / links_per_page) * links_per_page) + 1
    end

    def last_page_in_current_range
      current_range_first_page + links_per_page - 1
    end

    def previous_range_first_page
      previous_range_first_page = current_range_first_page - links_per_page
    end

    def next_range_first_page
      current_range_first_page + links_per_page
    end
  end

  # MAIN PAGINATION LINK HELPER
  def pagination_links(obj)
    paginator = Paginator.new(obj)
    paginator.current_page = params[:page]

    # PAGE BUTTON LINKS (w/Bootstap styling)
    def previous_page_link(paginator)
      content_tag :li do
        link_to({ controller: "#{controller_name}", action: "#{action_name}", page: paginator.previous_page }, { remote: true, :'aria-label' => 'Previous' }) do
          raw '<span aria-hidden="true">&laquo;</span>'
        end
      end
    end

    def previous_group_link(paginator)
      content_tag :li do
        link_to({ controller: "#{controller_name}", action: "#{action_name}", page: paginator.previous_range_first_page }, { remote: true, :'aria-label' => 'Next Pages' }) do
          raw '<span aria-hidden="true">...</span>'
        end
      end
    end

    def page_link(page_num, current_page)
      status = 'active' if page_num == current_page

      content_tag :li, class: "#{status}" do
        link_to("#{page_num}", controller: "#{controller_name}", action: "#{action_name}", page: "#{page_num}", remote: true)
      end
    end

    def next_group_link(paginator)
      content_tag :li do
        link_to({ controller: "#{controller_name}", action: "#{action_name}", page: paginator.next_range_first_page }, { remote: true, :'aria-label' => 'Next Pages' }) do
          raw '<span aria-hidden="true">...</span>'
        end
      end
    end

    def next_page_link(paginator)
      content_tag :li do
        link_to({ controller: "#{controller_name}", action: "#{action_name}", page: paginator.next_page }, { remote: true, :'aria-label' => 'Next' }) do
          raw '<span aria-hidden="true">&raquo;</span>'
        end
      end
    end

    # BUILD PAGINATION LINKS
    # Start Bootstap pagination style
    output = '<nav class="text-center"><ul class="pagination">'

    # Show the '<<' aka previous page button
    unless paginator.first_page? || paginator.current_page < 1
      output += previous_page_link(paginator)
    end

    # Show the '...' aka previous page group button
    unless paginator.first_page? || paginator.current_page <= paginator.links_per_page
      output += previous_group_link(paginator)
    end

    # Show individual page links, stopping at the limit of links per page set by the user
    paginator.current_range_first_page.upto(paginator.last_page_in_current_range) do |page_num|
      output += page_link(page_num, paginator.current_page) unless page_num > paginator.total_pages
    end

    # Show the '...' aka next page group button
    unless paginator.next_range_first_page > paginator.total_pages || paginator.last_page?
      output += next_group_link(paginator)
    end

    # Show the '>>' aka next page button
    unless paginator.last_page? || paginator.current_page > paginator.total_pages
      output += next_page_link(paginator)
    end

    # Append page numbering and end Bootstap pagination style
    output += "</ul><p><strong>Page:</strong> #{paginator.current_page} / #{paginator.total_pages}</p></nav>"

    # Output the string to the view
    raw output
  end

end
