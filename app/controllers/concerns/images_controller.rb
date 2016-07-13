class ImagesController < ApplicationController
	skip_before_action :verify_authenticity_token

  require 'docker'

  def index
    #@images = JSON.parse Docker.connection.get('/images/json')
    @images = Docker::Image.all
  rescue => e
    Rails.logger.error e.message
    Rails.logger.error e.backtrace.join "\n"
    flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_not_running')
  end
end