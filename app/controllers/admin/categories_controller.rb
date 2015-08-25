class Admin::CategoriesController < ApplicationController
  before_action :authenticate
  before_action :require_admin
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
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = "The category was updated."
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  private

  def find_category
    @category = Category.find_by!(slug: params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
