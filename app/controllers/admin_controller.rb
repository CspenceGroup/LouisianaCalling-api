class AdminController < ApplicationController
  http_basic_authenticate_with :name => 'admin', :password => 'anhhau'

  def index
     p 'aaaaa'
  end

  def new
  end

  def create
  end

  def destroy
  end

  def upload
    logger.debug "asd"
    # file_data = params[:attachment]
    # if file_data.respond_to?(:read)
    #   xml_contents = file_data.read

    #   render :json => {:data => xml_contents}
    # elsif file_data.respond_to?(:path)
    #   xml_contents = File.read(file_data.path)
    # else
    #   logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
    # end

    render :json => {:data => '223111'}
  end
end
