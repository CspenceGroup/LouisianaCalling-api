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
              topJobs[:region] = row[0].strip
              topJobs[:job_title] = row[1].strip

              if row[2]
                raise "error"
              end

              topJobs.save!
            end
          end

          Region.transaction do
            Region.delete_all
            csv.each do |row|
              if !Region.exists?(name: row[0].strip)
                region = Region.new
                region[:name] = row[0].strip
                region.save!
              end
            end
          end
        when name="homePageVideo"
          Video.transaction do
            Video.delete_all

            csv.each do |row|
              video = Video.new
              video[:title] = row[0].strip
              video[:url] = row[1].strip
              video[:main_title] = row[2].strip
              video[:description] = row[3].strip

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
              interest[:name] = row[0].strip
              interest[:url] = row[1].strip

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
              skill[:name] = row[0].strip
              skill[:url] = row[1].strip

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
              cluster[:name] = row[0].strip

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
              profile[:first_name] = row[0].strip
              profile[:last_name] = row[1].strip
              profile[:job_title] = row[2].strip
              # profile[:education] = row[3]
              profile[:region] = row[4].strip
              profile[:description] = row[5].strip

              if row[6]
                profile[:interests] = row[6].split(',').map{ |s| s.strip }
              end

              if row[7]
                profile[:skills] = row[7].split(',').map{ |s| s.strip }
              end

              profile[:demand] = row[8].strip
              profile[:cluster] = row[9].strip
              profile[:salary] = row[10].strip
              profile[:education] = row[11].strip
              profile[:video] = row[12].strip
              profile[:image_medium] = row[13].strip
              profile[:image_small] = row[14].strip
              profile[:image_large] = row[15].strip

              if row[16]
                raise "error"
              end

              profile.save!
            end
          end

          when name="careers"
            Career.transaction do
              Career.delete_all

              csv.each do |row|
                career = Career.new
                career[:title] = row[0].strip
                career[:slug] = row[0].parameterize
                career[:region] = row[1].strip
                career[:industries] = []

                for i in 2..5
                  if (row[i] != "" && row[i] != nil) then
                    career[:industries] << row[i].strip
                  end
                end

                career[:skills] = row[6].split(',').map{ |s| s.strip }
                career[:interests] = row[7].split(',').map{ |s| s.strip }
                career[:salary_min] = row[8].strip
                career[:salary_max] = row[9].strip
                career[:education] = row[10].strip
                career[:about_job] = row[11].strip
                career[:what_will_do] = row[12].strip
                career[:related_career_by_skill] = row[13].split(',').map{ |s| s.strip }
                career[:related_career_by_interest] = row[14].split(',').map{ |s| s.strip }
                career[:demand] = row[15].strip
                career[:photo_large] = row[16].strip
                career[:photo_medium] = row[17].strip
                career[:photo_small] = row[18].strip
                career[:regions_high_demand] = row[19].split(',').map{ |s| s.strip }
                career[:profile_name] = row[20].strip

                if row[21]
                  raise "error"
                end

                career.save!
              end
            end

            when name="educations"
              Education.transaction do
                Education.delete_all

                csv.each do |row|
                  education = Education.new
                  education[:name] = row[0].strip

                  if row[1]
                    raise "error"
                  end

                  education.save!
                end
              end
      end

      flash[:notice] = "Document was successfully uploaded."

    rescue => ex
      logger.debug ex
      flash[:notice] = "Error"
    end
    redirect_to action: "index"
  end

  private
  def csv_params
    params.permit(:name, :attachment)
  end
end
