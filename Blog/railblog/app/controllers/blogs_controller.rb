# -*- coding: utf-8 -*-
class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    search = params[:search]
    if search.blank? then 
      # Blog.ページ.表示数.ソート対象
      @blogs = Blog.page(params[:page]).per(5).order(:id)
    else
      tags_id = Tag.where(:name => search.split(",")).pluck(:id)
      blogs_id = BlogTag.where(:tag_id => tags_id).pluck(:blog_id)
      @blogs = Kaminari.paginate_array(Blog.where(:id => blogs_id)).page(params[:page]).per(5)
    end
  end

  def management
    @blogs = Blog.page(params[:page]).per(5).order(:id)
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_param)
    respond_to do |format|        
      unless @blog.dating then
        @blog.dating = Time.now
      end
      if @blog.save
        tags = params[:tag].gsub(/\s|　/,"").split(",")
        tags.each do |temp|
          @blog.tag.find_or_create_by(name: temp)
        end
        format.html { redirect_to @blog, notice: '記事の作成をしました。' }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      if @blog.dating < Time.now
        @blog.dating = Time.now
      end
      if @blog.update(blog_param)
        tags = params[:tag].gsub(/\s|　/,"").split(",")
        tags.each do |temp|
          @blog.tag.find_or_create_by(name: temp)
        end
        format.html { redirect_to @blog, notice: '記事の更新をしました。' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    @blog.destroy
    respond_to do |format|
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.' }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_param
      params.require(:blog).permit(:title, :word, :dating)
    end
end
