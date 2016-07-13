class DockerfilesController < ApplicationController
	 skip_before_action :verify_authenticity_token

  def index
    path = Pathname.pwd + "dockerfiles/"
    directory = Dictionary.new
    @directory = directory.get_path_content path
  end

  def create
    file = params[:file]
    directory = Dictionary.new
    @path = directory.get_absolute_path file
    @content = params[:content]
    File.open(@path, "w") do |f|
      f.write(@content)
    end
      redirect_to dockerfiles_index_path
  rescue Exception => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join "\n"
    flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_can_not_read_file') + file
    redirect_to dockerfiles_index_path
  end

  def delete
    file = params[:file]
    directory = Dictionary.new
    @path = directory.get_absolute_path file
    File.delete(@path)
    redirect_to dockerfiles_index_path
  end

  def edit
    @file = params[:file]
    directory = Dictionary.new
    @content = directory.get_file_content @file
  rescue Exception => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join "\n"
    flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_can_not_read_file') + @file
    redirect_to dockerfiles_index_path
  end

  def save
     file = params[:file]
     directory = Dictionary.new
     @path = directory.get_absolute_path file
     @content = params[:content]
     File.open(@path, "w") do |f|
       f.write(@content)
     end
     redirect_to dockerfiles_index_path
   rescue Exception => e
     Rails.logger.error e.message
     Rails.logger.error e.backtrace.join "\n"
     flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_can_not_read_file') + file
     redirect_to dockerfiles_index_path
  end

  def new

  end
end
