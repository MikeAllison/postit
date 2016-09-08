class Admin::CategoriesController < ApplicationController
  before_action :authenticate
  before_action :require_admin
  before_action :find_category, only: [:show, :edit, :update, :toggle_hidden]

  def index
    @categories = Category.unscope(where: :hidden)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = 'A new category was created.'
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = 'The category was updated.'
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def toggle_hidden
    @category.hidden? ? @category.unhide! : @category.hide!

    respond_to do |format|
      format.html { redirect_to admin_categories_path }
      format.js { render 'update_category_list' }
    end
  end

  private

  def find_category
    @category = Category.unscope(where: :hidden).find_by!(slug: params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
