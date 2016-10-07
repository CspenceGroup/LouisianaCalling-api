module ProgramHelper
  include ApplicationHelper

  def industries_query_str(industry_ids)
    industry_ids = industry_ids.split(',')
    list_of_clusters = convert_industries_to_hash
    industries_q = ['(']

    industry_ids.each_with_index do |id, index|
      if index.zero?
        industries_q.push "industries like '%#{list_of_clusters[id.to_i]}%'"
      else
        industries_q.push " OR industries like '%#{list_of_clusters[id.to_i]}%'"
      end
    end
    industries_q.push ')'

    industries_q.join('')
  end
end
