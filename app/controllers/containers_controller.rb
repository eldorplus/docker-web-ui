class ContainersController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	require 'docker'

	def index
		@containers = Docker::Container.all(all: true)
	rescue Exception => e
    	Rails.logger.error e.message
    	Rails.logger.error e.backtrace.join "\n"
    	flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_not_running')
		redirect_to root_path
	end

	def new
		if defined? params
			image = params[:image]
			@search = Docker::Image.search('term' => image)
		end
	rescue Exception => e
		Rails.logger.error e.message
		Rails.logger.error e.backtrace.join "\n"
		flash[:error] = t('error_occured') + " (#{e.message}). " + t('error_unreachable')
	end

	def setup
		if defined? params
			@image = params[:id]
		end
	rescue Exception => e
		Rails.logger.error e.message
		Rails.logger.error e.backtrace.join "\n"
		flash[:error] = t('error_occured') + " (#{e.message}). " + t('error_unreachable')
	end

	def create
		portmapping = params[:portmapping]
		ipadress, hostport, containerport = portmapping.split(":")
		env = params[:env]

		container = Hash.new

		if params[:hostname]
			container['Hostname'] = params[:hostname]
		end
		if params[:image]
			container['Image'] = params[:image]
		else
			container['Image'] = 'debian:latest'
		end
		name = Array.new
		if params[:name]
			name['name'] = params[:name]
		else
			name['name'] = 'clwddockerautomation'
		end
		container['Cmd'] = params[:command]
		container['HostConfig'] = Hash.new
		#container['HostConfig']['Ulimits'] = Array.new
		#container['HostConfig']['Ulimits'] = name
		#"Dns": ["8.8.8.8"],
		container['HostConfig']['PortBindings'] = Hash.new
		container['HostConfig']['PortBindings'][hostport.to_s+ '/tcp'] = [{:HostPort => containerport}]
		container['Env'] = env

		@container = Docker::Container.create(container).start

		flash[:success] = t('success_containers_started')
		@containerjson = @container.json
		redirect_to containers_index_path
	rescue Exception => e
    	Rails.logger.error e.message
    	Rails.logger.error e.backtrace.join "\n"
    	flash[:error] = t('error_occured') + " (#{e.message}). " + t('error_container_same_exist')
    	#redirect_to images_index_path
  	end

  def start
		cid = params[:id]
		@container = Docker::Container.get(cid)
		@container.start

		@container = Docker::Container.get(cid)
		state = @container.info['State']['Status']

		if state == 'running'
			flash[:success] = t('success_containers_started')
			redirect_to containers_index_path
		else
			flash[:error] = t('error_containers_started')
			redirect_to containers_index_path
		end
	rescue => e
		Rails.logger.error e.message
		Rails.logger.error e.backtrace.join "\n"
		flash[:error] = t('error_occured') + " (#{e.message}). " + t('error_containers_delete')
		redirect_to containers_index_path
	end

	def stop
		cid = params[:id]
		@container = Docker::Container.get(cid)
		@container.stop

		@container = Docker::Container.get(cid)
		state = @container.info['State']['Status']

		if state == 'exited'
			flash[:success] = t('success_containers_stoped')
			redirect_to containers_index_path
		else
			flash[:error] = t('error_occured') + " " + t('error_containers_started')
			redirect_to containers_index_path
		end
	end

	def show
		if defined? params
			cid = params[:id]
			@containers = Docker::Container.all(all: true)
			@container = Docker::Container.get(cid)
			@logs = @container.logs(stdout: true, stderr: true)
			@container =  @container.json
		else
			redirect_to containers_index_path
		end
	end

	def delete
		cid = params[:id]
		@container = Docker::Container.get(cid)
		state = @container.info['State']['Status']
		if state == 'running'
			flash[:error] = t('error_occured') + " " + t('error_containers_first_stoped')
		elsif state == 'exited'
			@container.remove
			flash[:success] = t('success_containers_has_ben_deleted')
		else
			flash[:error] = t('error_occured') + " " + t('error_containers_unknown') + " " + t('error_containers_is_still')
		end
		redirect_to containers_index_path
	rescue => e
		Rails.logger.error e.message
		Rails.logger.error e.backtrace.join "\n"
		flash[:error] = t('error_occured') + " " + t('error_containers_is_still')
		redirect_to containers_index_path
	end

end