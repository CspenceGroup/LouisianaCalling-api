require 'csv'

class AdminController < ApplicationController
  http_basic_authenticate_with :name => 'admin', :password => 'hz4q9WETPC3Gyr9g'

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
        when name="homePageTopJobs"
          TopJob.transaction do
            TopJob.delete_all
            csv.each do |row|
              topJobs = TopJob.new
              topJobs[:region] = row[0]
              topJobs[:job_title] = row[1]

              if row[2]
                raise "error"
              end

              topJobs.save!
            end
          end
        when name="homePageVideo"
          Video.transaction do
            Video.delete_all

            csv.each do |row|
              video = Video.new
              video[:title] = row[0]
              video[:url] = row[1]
              video[:main_title] = row[2]
              video[:description] = row[3]

              if row[4]
                raise "error"
              end

              video.save!
            end
          end

        when name="interests"
          Interest.transaction do
            Interest.delete_all

            csv.each do |row|
              interest = Interest.new
              interest[:name] = row[0]
              interest[:url] = row[1]

              if row[2]
                raise "error"
              end

              interest.save!
            end
          end

        when name="skills"
          Skill.transaction do
            Skill.delete_all

            csv.each do |row|
              skill = Skill.new
              skill[:name] = row[0]
              skill[:url] = row[1]

              if row[2]
                raise "error"
              end

              skill.save!
            end
          end

        when name="clusters"
          Cluster.transaction do
            Cluster.delete_all

            csv.each do |row|
              cluster = Cluster.new
              cluster[:name] = row[0]

              if row[1]
                raise "error"
              end

              cluster.save!
            end
          end

        when name="profiles"
          Profile.transaction do
            Profile.delete_all

            csv.each do |row|
              profile = Profile.new
              profile[:first_name] = row[0]
              profile[:last_name] = row[1]
              profile[:job_title] = row[2]
              profile[:region] = row[3]
              profile[:facebook] = row[4]
              profile[:twitter] = row[5]
              profile[:email] = row[6]
              profile[:description] = row[7]

              if row[8]
                profile[:interests] = row[8].split(',')
              end

              if row[9]
                profile[:skills] = row[9].split(',')
              end

              profile[:demand] = row[10]
              profile[:cluster] = row[11]
              profile[:salary] = row[12]
              profile[:education] = row[13]
              profile[:video] = row[14]

              if row[15]
                raise "error"
              end

              profile.save!
            end
          end

      end

      flash[:notice] = "Document was successfully uploaded."

    rescue => ex
      flash[:notice] = "Error"
    end
    redirect_to action: "index"
  end

  private
  def csv_params
    params.permit(:name, :attachment)
  end
end
