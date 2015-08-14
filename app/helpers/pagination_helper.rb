module PaginationHelper

  class Paginator

    attr_accessor :items_per_page

    def initialize(obj, items_per_page)
      @items_per_page = items_per_page
      @obj = obj
    end

    def total_pages
      (@obj.size / @items_per_page) + 1 if (@obj.size % @items_per_page > 0)
    end

  end


  def paginate(obj, items_per_page)
    paginator = Paginator.new(obj, items_per_page)
    "#{paginator.total_pages}"
  end

  def prev_page_link
    if params[:page].to_i > 1
      content_tag :li do
        link_to posts_path(page: @current_page - 1), { :'aria-label' => 'Previous' } do
          raw '<span aria-hidden="true">&laquo;</span>'
        end
      end
    end
  end

  def prev_page_group_link
    if @current_page > 1
      content_tag :li do
        link_to posts_path(page: @current_page), { :'aria-label' => 'Next Pages' } do
          raw '<span aria-hidden="true">...</span>'
        end
      end
    end
  end

  def page_links
    @current_page.upto(@current_page + (@num_of_page_links - 1)) do |p|
      concat(content_tag :li, link_to("#{p + 1}", posts_path(page: "#{p + 1}")))
    end
  end

  def next_page_group_link
    if @current_page < @total_pages
      content_tag :li do
        link_to posts_path(page: @current_page + @num_of_page_links + 1), { :'aria-label' => 'Next Pages' } do
          raw '<span aria-hidden="true">...</span>'
        end
      end
    end
  end

  def next_page_link
    if @current_page < @total_pages
      content_tag :li do
        link_to posts_path(page: @current_page + 1), { :'aria-label' => 'Next' } do
          raw '<span aria-hidden="true">&raquo;</span>'
        end
      end
    end
  end

end
