module PaginationHelper

  class Paginator
    attr_reader :links_per_page
    attr_accessor :current_page

    def initialize(obj, items_per_page, links_per_page)
      @items_per_page = items_per_page
      @obj = obj
      @links_per_page = links_per_page
    end

    def total_pages
      total_pages = @obj.size / @items_per_page
      total_pages += 1 if @obj.size % @items_per_page > 0
      total_pages
    end

    def current_page
      current_page = (@current_page ||= 1).to_i
      current_page = 1 if current_page < 1
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

    def previous_range_first_page
      previous_range_first_page = current_range_first_page - links_per_page
    end

    def next_range_first_page
      current_range_first_page + links_per_page
    end
  end

  # MAIN PAGINATION METHOD
  def paginate(obj, items_per_page, links_per_page)
    paginator = Paginator.new(obj, items_per_page, links_per_page)
    paginator.current_page = params[:page]

    # PAGE BUTTON LINKS (w/Bootstap styling)
    def previous_page_link(paginator)
      content_tag :li do
        link_to posts_path(page: paginator.previous_page), { :'aria-label' => 'Previous' } do
          raw '<span aria-hidden="true">&laquo;</span>'
        end
      end
    end

    def previous_group_link(paginator)
      content_tag :li do
        link_to posts_path(page: paginator.previous_range_first_page), { :'aria-label' => 'Next Pages' } do
          raw '<span aria-hidden="true">...</span>'
        end
      end
    end

    def page_link(page_num)
      content_tag :li do
        link_to "#{page_num}", posts_path(page: "#{page_num}")
      end
    end

    def next_group_link(paginator)
      content_tag :li do
        link_to posts_path(page: paginator.next_range_first_page), { :'aria-label' => 'Next Pages' } do
          raw '<span aria-hidden="true">...</span>'
        end
      end
    end

    def next_page_link(paginator)
      content_tag :li do
        link_to posts_path(page: paginator.next_page), { :'aria-label' => 'Next' } do
          raw '<span aria-hidden="true">&raquo;</span>'
        end
      end
    end

    # Start Bootstap pagination style
    output = '<nav class="text-center"><ul class="pagination">'

    # Show the '<<' aka previous page button
    unless paginator.first_page? || paginator.current_page < 1
      output += previous_page_link(paginator)
    end

    # Show the '...' aka previous group button
    unless paginator.first_page? || paginator.current_page <= paginator.links_per_page
      output += previous_group_link(paginator)
    end

    # Show individual page links, stopping at the limit of links per page set by the user
    paginator.current_range_first_page.upto(paginator.current_range_first_page + paginator.links_per_page - 1) do |page_num|
      output += page_link(page_num) unless page_num > paginator.total_pages
    end

    # Show the '...' aka next group button
    unless paginator.next_range_first_page > paginator.total_pages || paginator.last_page?
      output += next_group_link(paginator)
    end

    # Show the '>>' aka next page button
    unless paginator.last_page? || paginator.current_page > paginator.total_pages
      output += next_page_link(paginator)
    end

    # End Bootstap pagination style
    output += '<ul></nav>'

    # Output the string to the view
    raw output
  end

end
