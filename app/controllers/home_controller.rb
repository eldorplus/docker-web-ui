class HomeController < ApplicationController

	require 'docker'

	def index
		begin
			@infos = Docker.version
		rescue Exception => e
			Rails.logger.error e.message
			Rails.logger.error e.backtrace.join "\n"
			flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_not_running')
		end
	end
end