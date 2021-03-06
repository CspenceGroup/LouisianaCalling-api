class GuidedJourneyController < ApplicationController
  include CareerHelper
  before_action :datas_for_binding, only: [:index]

  def index
  end

  def search
    @limit = params[:limit] || 10
    @offset = params[:offset] || 0

    @limit = @limit.to_i
    @offset = @offset.to_i

    careers = Career.all

    ## filter by regions
    if params[:regions].present?
      region_name = params[:regions].split(',').map(&:downcase)

      region_ids = Region.filter_by_names(region_name).distinct.map(&:id)
      careers = careers.filter_with_region(region_ids).distinct
    end

    # ## filter by skill
    if params[:skills].present?
      careers = careers.filter_by_skill(params[:skills].split(',')).distinct
    end

    ## filter by education
    if params[:educations].present?
      careers = careers.filter_by_education(params[:educations].split(',')).distinct
    end

    ## filter by interests
    if params[:interests].present?
      careers = careers.filter_by_interest(params[:interests].split(',')).distinct
    end

    next_offset = @limit + @offset
    is_see_more = careers.count > next_offset ? true : false

    # Sorting by high demand
    careers = careers.high_demand

    careers = Kaminari.paginate_array(careers).offset(@offset).limit(@limit)

    render json: {
      careers: render_to_string(
        'guided_journey/partial/_guided-career-result', layout: false, locals: { careers: careers }
      ),
      is_see_more: is_see_more,
      offset: next_offset,
      limit: @limit
    }
  end

  private

  def datas_for_binding
    @regions = Region.all.alphabetical
    @educations = Education.all.alphabetical
    @skills = Skill.all.alphabetical
    @interests = Interest.all.alphabetical
  end
end
