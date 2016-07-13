class ImagesController < ApplicationController
	skip_before_action :verify_authenticity_token

	require 'docker'

	def index
		@images = Docker::Image.all
	rescue Exception => e
		Rails.logger.error e.message
		Rails.logger.error e.backtrace.join "\n"
		flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_not_running')
		redirect_to root_path
	end

	def show
		cid = params[:id]
		@image = Docker::Image.get(cid)
		@history = @image.history
	rescue Exception => e
		Rails.logger.error e.message
		Rails.logger.error e.backtrace.join "\n"
		flash[:error] = t('error_occured') + " (#{e.message}). " + t('image_maybe_offline')
		redirect_to images_index_path
	end

	def create
		file = params[:file]
		cid = params[:id]
		cname = params[:name]
		format = params[:format]
		if format == "rename"
			@image = Docker::Image.get(cid)
			@image.tag('repo' => cname, 'force' => true)
		#elsif format == "create"
		#	@image = cid # reiz/mongodb:1.0.0
		#	@split = image.split(":")
		#	@name = @split.first
		#	@tag = @split.last
		#	builder_image @name, @tag
		#	flash[:success] = "La création a été déclenchée. Cela peut prendre quelques minutes. Merci de rafraîchir régulièrement la page."
		else
			directory = Dictionary.new
			@content = directory.get_file_content cid
			begin
				image = Docker::Image.build(@content)
				image.tag('repo' => "clwddockerautomation/"+ file, 'force' => true)
			rescue Exception => e
				Rails.logger.error e.message
				Rails.logger.error e.backtrace.join "\n"
				flash[:notice] = t('error_occured') + " (#{e.message}). Don't create"
			end
		end
		redirect_to images_index_path
  	rescue Exception => e
    	Rails.logger.error e.message
    	Rails.logger.error e.backtrace.join "\n"
    	flash[:error] = t('error_occured') + " (#{e.message}). " + t('docker_can_not_read_file') + cid
    	redirect_to images_index_path
	end

	def new
		cid = params[:format]
		@image = Docker::Image.create('fromImage' => cid)
		@image.tag('repo' => "clwddockerautomation/"+ cid, 'force' => true)
		flash[:success] = "Created with success"
		redirect_to images_index_path
	rescue Exception => e
		Rails.logger.error e.message
		Rails.logger.error e.backtrace.join "\n"
		flash[:error] = t('error_occured') + " (#{e.message}). " + t('image_maybe_offline')
		redirect_to images_index_path
	end

	def delete
		cid = params[:id]
		if Docker::Image.exist?(cid)
			image = Docker::Image.get(cid)
			image.remove
			if !Docker::Image.exist?(cid)
				flash[:success] = t('image_removing_success')
			else
				flash[:error] = t('error_occured') + " " + t('image_removing_error')
			end
		end
		redirect_to images_index_path
	end

  private
    def builder_image name, tag
      Thread.new {
        begin
          uri    = "/images/create?fromImage=#{name}&tag=#{tag}"
          config = config_for "#{name}:#{tag}"
          auth   = config['auth']
          container = nil
          if auth == true
            user     = ENV['DOCKER_USER']
            password = ENV['DOCKER_PASSWORD']
            email    = ENV['DOCKER_EMAIL']
            options = {"username" => user, "password" => password, "email" => email}
            creds = options.to_json
            headers = Docker::Util.build_auth_header(creds)
            container = Docker.connection.post( uri, {}, :headers => headers )
          else
            container = Docker.connection.post( uri )
          end
          Rails.logger.info "Done with #{name}. - #{container.to_s}"
        rescue Exception => e
          p "error for POST /images/create?fromImage=#{name}&tag=#{tag}"
          Rails.logger.error e.message
          Rails.logger.error e.backtrace.join "\n"
        end
      }
    end

end