class BoardSessionsController < ApplicationController
  def save
    session[:title] = params[:title]
    session[:body] = params[:body]
    session[:tag_names] = params[:tag_names]
    puts "#{session[:tag_names]}"
    redirect_to pictures_path
  end

  def clear
    session[:title] = nil
    session[:body] = nil
    session[:tag_names] = nil
    session[:image_url] = nil
    redirect_to root_path
  end
end
