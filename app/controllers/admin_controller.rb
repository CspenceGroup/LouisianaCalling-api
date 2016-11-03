require 'csv'

class AdminController < ApplicationController
  # http_basic_authenticate_with :name => 'admin', :password => 'hz4q9WETPC3Gyr9g'

  def index
    @name = params[:name] || 'regions'
  end

  def new
  end

  def create
  end

  def destroy
  end

  def upload
    begin
      name = params[:name]
      attachment = params[:attachment]
      csv_text = ''

      if attachment.respond_to?(:path)
        csv_text = File.read(attachment.path)
      else
        logger.error "Bad file_data: #{attachment.class.name}: #{attachment.inspect}"
      end

      csv = CSV.parse(csv_text, headers: true, col_sep: "\t")

      raise 'error' if csv.empty?

      case name
      when 'regions'
        Region.import_from_csv(csv)
      when 'top_jobs'
        TopJob.import_from_csv(csv)

      when 'videos'
        Video.import_from_csv(csv)

      when 'interests'
        Interest.import_from_csv(csv)

      when 'skills'
        Skill.import_from_csv(csv)

      when 'clusters'
        Cluster.import_from_csv(csv)

      when 'profiles'
        Profile.import_from_csv(csv)

      when 'careers'
        Career.import_from_csv(csv)

      when 'careers_region'
        CareerRegion.import_from_csv(csv)

      when 'educations'
        Education.import_from_csv(csv)

      when 'programs'
        Program.import_from_csv(csv)
      end

      flash[:notice] = "#{attachment.original_filename} was successfully uploaded."

    rescue => ex
      flash[:notice] = ex
    end
    @name = name
    redirect_to action: 'index', name: @name
  end

  private

  def csv_params
    params.permit(:name, :attachment)
  end
end
