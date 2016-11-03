require 'csv'

class AdminController < ApplicationController
  # http_basic_authenticate_with :name => 'admin', :password => 'hz4q9WETPC3Gyr9g'

  def index
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

      csv = CSV.parse(csv_text, :headers => true, :col_sep => "\t")

      if csv.length == 0
        raise "error"
      end

      case name
        when 'regions'
          Region.import_from_csv(csv)
        when name="homePageTopJobs"
          TopJob.import_from_csv(csv)

        when name="homePageVideo"
          Video.import_from_csv(csv)

        when name="interests"
          Interest.import_from_csv(csv)

        when name="skills"
          Skill.import_from_csv(csv)

        when name="clusters"
          Cluster.import_from_csv(csv)

        when name="profiles"
          Profile.import_from_csv(csv)

        when name="careers"
          Career.import_from_csv(csv)

        when name="careers_region"
          CareerRegion.import_from_csv(csv)

        when name="educations"
          Education.import_from_csv(csv)

        when name="programs"
          Program.import_from_csv(csv)
      end

      flash[:notice] = "Document was successfully uploaded."

    rescue => ex
      flash[:notice] = ex
    end
    redirect_to action: "index"
  end

  private
  def csv_params
    params.permit(:name, :attachment)
  end
end
