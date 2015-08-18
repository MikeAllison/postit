module PaginationHelper

  class Paginator
    attr_reader :links_per_page

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
  end

  # MAIN PAGINATION METHOD
  def paginate(obj, items_per_page, links_per_page)
    paginator = Paginator.new(obj, items_per_page, links_per_page)

    # Start Bootstap pagination style
    output = '<nav class="text-center"><ul class="pagination">'

    # Show the '<<' aka previous page button
    unless first_page? || current_page < 1
      output += prev_page_link
    end

    # Show the '...' aka previous group button
    unless first_page? || current_page <= paginator.links_per_page
      output += prev_page_group_link(paginator)
    end

    # Show individual page links, stopping at the limit of links per page set by the user
    current_range_start.upto(paginator.links_per_page) do |page_num|
      output += page_link(page_num) unless page_num > paginator.total_pages
    end

    # Show the '...' aka next group button
    unless next_range_start(paginator) > paginator.total_pages || last_page?(paginator)
      output += next_page_group_link(paginator)
    end

    # Show the '>>' aka next page button
    unless last_page?(paginator) || current_page > paginator.total_pages
      output += next_page_link
    end

    # End Bootstap pagination style
    output += '<ul></nav>'

    # Output the string to the view
    output.html_safe
  end

  # Does not work
  def paginate_page_info
    # "#{current_page} / #{paginator.total_pages}"
  end

  def current_page
    params[:page] ? current_page = params[:page].to_i : 1
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

  def last_page?(paginator)
    current_page == paginator.total_pages
  end

  def current_range_start
    1
  end

  def previous_range_start(paginator)
    previous_range_start = current_range_start - paginator.links_per_page
  end

  def next_range_start(paginator)
    current_range_start + paginator.links_per_page
  end

  # PAGE BUTTON LINKS (w/Bootstap styling)

  def prev_page_link
    content_tag :li do
      link_to posts_path(page: previous_page), { :'aria-label' => 'Previous' } do
        raw '<span aria-hidden="true">&laquo;</span>'
      end
    end
  end

  def prev_page_group_link(paginator)
    content_tag :li do
      link_to posts_path(page: previous_range_start(paginator)), { :'aria-label' => 'Next Pages' } do
        raw '<span aria-hidden="true">...</span>'
      end
    end
  end

  def page_link(page_num)
    content_tag :li do
      link_to "#{page_num}", posts_path(page: "#{page_num}")
    end
  end

  def next_page_group_link(paginator)
    content_tag :li do
      link_to posts_path(page: next_range_start(paginator)), { :'aria-label' => 'Next Pages' } do
        raw '<span aria-hidden="true">...</span>'
      end
    end
  end

  def next_page_link
    content_tag :li do
      link_to posts_path(page: next_page), { :'aria-label' => 'Next' } do
        raw '<span aria-hidden="true">&raquo;</span>'
      end
    end
  end

end
