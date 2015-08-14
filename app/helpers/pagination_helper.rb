module PaginationHelper

  class Paginator

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
    if true
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
    if true
      content_tag :li do
        link_to posts_path(page: @current_page + @num_of_page_links + 1), { :'aria-label' => 'Next Pages' } do
          raw '<span aria-hidden="true">...</span>'
        end
      end
    end
  end

  def next_page_link
    unless params[:page].to_i == @total_pages
      content_tag :li do
        link_to posts_path(page: @current_page + 1), { :'aria-label' => 'Next' } do
          raw '<span aria-hidden="true">&raquo;</span>'
        end
      end
    end
  end

end
