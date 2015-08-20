class CategoriesController < ApplicationController
  before_action :find_category, only: [:show]

  def show
    @posts = @category.posts.includes(:creator, :categories).votes_created_desc

    respond_to do |format|
      format.html
      format.js { render 'shared/reload_posts' }
    end
  end

  private

    def find_category
      @category = Category.find_by!(slug: params[:id])
    end

end
