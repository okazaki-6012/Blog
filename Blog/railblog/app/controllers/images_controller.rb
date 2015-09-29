# -*- coding: utf-8 -*-
class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :destroy]

  def index
    @images = Image.page(params[:page]).per(15)
  end

  def show_image
    @image = Image.find(params[:id])
    send_data @image.file, type: @image.ctype, disposition: :inline    
  end

  def new
    @image = Image.new
  end
 
  def create  
    file = image_params[:file]
    image = {}
    if file != nil then
      name = file.original_filename
      image[:ctype] = File.extname(name).downcase
      name = name.kconv(Kconv::SJIS, Kconv::UTF8)
      image[:name] = name
      image[:file] = file.read
    end
    perms = ['.jpg','.jpeg','.git','.png']
    @image = Image.new(image)      
    respond_to do |format|
      if !perms.include?@image.ctype
        # 画像ファイルのみです
        format.html { redirect_to new_image_path, notice: '画像ファイルのみ対応です。' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      elsif @image.file.size > 1.megabyte
        # ファイルサイズは1MB以下
        format.html { redirect_to new_image_path, notice: 'ファイルサイズは1MB以下です。' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      elsif @image.save then
        format.html { redirect_to @image, notice: '送信完了' }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render 'index' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url}
      format.json { head :no_content }
    end
  end

  private
   
    def set_image
      @image = Image.find(params[:id])
    end

    def image_params
      params.require(:image).permit(:name,:file)  
    end
end
