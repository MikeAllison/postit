module PaginationHelper

  class Paginator
    attr_accessor :items_per_page, :num_page_links

    def initialize(obj, items_per_page, num_page_links)
      @items_per_page = items_per_page
      @obj = obj
      @num_page_links = num_page_links
    end

    def total_pages
      total_pages = @obj.size / @items_per_page
      total_pages += 1 if @obj.size % @items_per_page > 0
      total_pages
    end
  end

  def current_page
    params[:page] ? current_page = params[:page].to_i : 1
  end

  def first_page?
    current_page == 1
  end

  def last_page?(paginator)
    current_page == paginator.total_pages
  end

  def current_page_range(paginator)
    page_range = []

    paginator.num_page_links.times do |page_num|
      page_range << page_num + 1
    end

    page_range
  end

  def paginate(obj, items_per_page, num_page_links)
    paginator = Paginator.new(obj, items_per_page, num_page_links)
    page_range = current_page_range(paginator)
    last_page = page_range.last

    output = '<nav class="text-center"><ul class="pagination">'
    output += prev_page_link unless first_page?
    output += prev_page_group_link unless first_page?

    paginator.num_page_links.times do |page_num|
      output += page_link(page_num + 1)
    end

    output += next_page_group_link(last_page + 1) unless last_page?(paginator)
    output += next_page_link unless last_page?(paginator)
    output += '<ul></nav>'

    raw output
  end

  def prev_page_link
    content_tag :li do
      link_to posts_path(page: current_page - 1), { :'aria-label' => 'Previous' } do
        raw '<span aria-hidden="true">&laquo;</span>'
      end
    end
  end

  def prev_page_group_link
    content_tag :li do
      link_to posts_path(page: current_page - 1), { :'aria-label' => 'Next Pages' } do
        raw '<span aria-hidden="true">...</span>'
      end
    end
  end

  def page_link(page_num)
    content_tag :li do
      link_to "#{page_num}", posts_path(page: "#{page_num}")
    end
  end

  def next_page_group_link(first_page)
    content_tag :li do
      link_to posts_path(page: first_page), { :'aria-label' => 'Next Pages' } do
        raw '<span aria-hidden="true">...</span>'
      end
    end
  end

  def next_page_link
    content_tag :li do
      link_to posts_path(page: current_page + 1), { :'aria-label' => 'Next' } do
        raw '<span aria-hidden="true">&raquo;</span>'
      end
    end
  end

end
