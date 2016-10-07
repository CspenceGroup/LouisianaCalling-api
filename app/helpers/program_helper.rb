module ProgramHelper
  include ApplicationHelper

  # Get regions query string
  def regions_query_str(region_ids)
    region_ids = region_ids.split(',')
    list_of_regions = convert_regions_to_hash

    regions = region_ids.map { |region| list_of_regions[region.to_i] }

    "region IN (#{regions.join(',')})"
  end

  # Get programs query string
  def programs_query_str(program_duration_ids)
    program_duration_ids = program_duration_ids.split(',')

  end
end
