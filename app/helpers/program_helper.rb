module ProgramHelper
  include ApplicationHelper

  # Get regions query string
  def regions_query_str(region_ids)
    region_ids = region_ids.split(',')
    list_of_regions = convert_regions_to_hash

    regions = region_ids.map { |region| "'#{list_of_regions[region.to_i]}'" }

    "region IN (#{regions.join(',')})"
  end

  # Get programs durations query string
  def programs_query_str(program_duration_ids)
    program_duration_ids = program_duration_ids.split(',')
    program_durations = Constants::PROGRAM_DURATIONS

    program_q = ['(']

    program_duration_ids.each_with_index do |id, index|
      if index.zero?
        program_q.push "duration like '%#{program_durations[id.to_i]}%'"
      else
        program_q.push "OR duration like '%#{program_durations[id.to_i]}%'"
      end
    end
    program_q.push ')'

    program_q.join('')
  end

  # Get times per week query string
  def hours_query_str(hour_per_week_ids)
    hour_per_week_ids = hour_per_week_ids.split(',')
    hours_per_weeks = Constants::HOURS_PER_WEEK

    hours_q = ['(']

    hour_per_week_ids.each_with_index do |id, index|
      if index.zero?
        hours_q.push "hours_per_weeks like '%#{hours_per_weeks[id.to_i]}%'"
      else
        hours_q.push "OR hours_per_weeks like '%#{hours_per_weeks[id.to_i]}%'"
      end
    end
    hours_q.push ')'

    hours_q.join('')
  end

  # Get time of day query string
  def times_query_str(time_of_day_ids)
    time_of_day_ids = time_of_day_ids.split(',')
    times_of_day = Constants::TIME_OF_DAY

    times_q = ['(']

    time_of_day_ids.each_with_index do |id, index|
      if index.zero?
        times_q.push "time_of_day like '%#{times_of_day[id.to_i]}%'"
      else
        times_q.push "OR time_of_day like '%#{times_of_day[id.to_i]}%'"
      end
    end
    times_q.push ')'

    times_q.join('')
  end
end
