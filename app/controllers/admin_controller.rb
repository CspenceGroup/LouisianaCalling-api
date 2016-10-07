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
                raise "Wrong file"
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
              video[:profile_name] = row[2].strip
              video[:description] = row[3].strip

              if row[4]
                raise "Wrong file"
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
                raise "Wrong file"
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
                raise "Wrong file"
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
                raise "Wrong file"
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
                raise "Wrong file"
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
                career[:industries] = []

                for i in 1..4
                  if (row[i] != "" && row[i] != nil) then
                    career[:industries] << row[i].strip
                  end
                end

                career[:skills] = row[5].split(',').map{ |s| s.strip }
                career[:interests] = row[6].split(',').map{ |s| s.strip }
                career[:salary_min] = row[7].strip
                career[:salary_max] = row[8].strip
                career[:education] = row[9].strip
                career[:about_job] = row[10].strip
                career[:what_will_do] = row[11].strip
                career[:related_career_by_skill] = row[12].split(',').map{ |s| s.strip }
                career[:related_career_by_interest] = row[13].split(',').map{ |s| s.strip }
                career[:demand] = row[14].strip
                career[:photo_large] = row[15].strip
                career[:photo_medium] = row[16].strip
                career[:photo_small] = row[17].strip
                career[:regions_high_demand] = row[18].split(',').map{ |s| s.strip }
                career[:profile_name] = row[19].strip if row[19]

                if row[20]
                  raise "Wrong file"
                end

                career.save!
              end
            end

          when name="careers_region"
            CareerRegion.transaction do
              CareerRegion.delete_all

              csv.each do |row|
                careerRegion = CareerRegion.new
                careerRegion[:title] = row[0].strip
                careerRegion[:slug] = row[0].parameterize
                careerRegion[:region] = row[1].strip
                careerRegion[:salary_min] = row[2].strip
                careerRegion[:salary_max] = row[3].strip
                careerRegion[:education] = row[4].strip

                if row[5]
                  raise "Wrong file"
                end

                careerRegion.save!
              end
            end


          when name="educations"
            Education.transaction do
              Education.delete_all

              csv.each do |row|
                education = Education.new
                education[:name] = row[0].strip

                if row[1]
                  raise "Wrong file"
                end

                education.save!
              end
            end

            when name="programs"
              Program.transaction do
                Program.delete_all

                csv.each_with_index do |row, index|
                  program = Program.new
                  program[:title] = row[0].strip
                  program[:id] = index + 1
                  program[:slug] = row[0].parameterize + '-' + (index + 1).to_s
                  program[:region] = row[1].strip
                  program[:traning_detail] = row[2].strip
                  program[:description] = row[3].strip
                  program[:duration] = row[4].strip
                  program[:time_of_day] = row[5].strip
                  program[:hours_per_weeks] = row[6].strip
                  program[:tuition_min] = row[7].strip
                  program[:tuition_max] = row[8].strip
                  program[:education] = row[9].strip
                  program[:institution_name] = row[10].strip
                  program[:phone] = row[11].strip
                  program[:address] = row[12].strip

                  location = row[13].split(',').map{ |s| s.strip }
                  program[:lat] = location[0]
                  program[:lng] = location[1]

                  program[:industries] = []

                  for i in 14..17
                    if (row[i] != "" && row[i] != nil) then
                      program[:industries] << row[i].strip
                    end
                  end

                  program[:cover_photo] = row[18].strip
                  program[:career] = row[19].split(';').map{ |s| s.strip }

                  if row[20]
                    raise "Wrong file"
                  end

                  program.save!
                end
              end
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
