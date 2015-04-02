class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "A new category was created."
      redirect_to categories_path
    else
      render :new
    end
  end

  def show
    @posts = @category.posts.includes(:creator, :categories, :comments)
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = "The category was updated."
      redirect_to categories_path
    else
      render :new
    end
  end

  private

    def find_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

end
