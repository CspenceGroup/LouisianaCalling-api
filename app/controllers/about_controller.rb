require 'json'
require 'open-uri'

class AboutController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_filter :categories_list, only: [:index, :create, :search]

  def index
    @contact = Contact.new
    @tab = params[:tab]
    tabs = %w(who-we-are our-community faq contact-us)

    @tab = 'our-community' if !@tab.present? || !tabs.include?(@tab)

    @searching = params[:key].present?

    return unless @searching

    @results = search_results
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      flash[:notice] = 'Your message has successfully sent out.'
    else
      # Handling error messages
      errors = @contact.errors.messages
      msg_errors = []

      errors.each do |key, values|
        msg_errors << "#{key.capitalize} #{values[0]}"
      end

      flash[:errors] = msg_errors.flatten
    end

    @tab = 'contact-us'
    render :index
  end

  private

  def search_results
    results = []
    faq_json_file = File.read(File.expand_path("#{Rails.root}/public/faq.json", __FILE__))

    categories = JSON.parse(faq_json_file).to_a

    categories.each do |category|
      questions = category['questions'].to_a

      questions.each do |question|
        if question['content'].include?(params[:key]) || question['answer'].include?(params[:key])
          results.push({
            category: category['name'],
            content: question['content'],
            answer: question['answer']
          })
        end
      end
    end
    limit = params[:limit] + params[:offset]
    {
      count: results.count,
      objects: results,
      limit: params[:limit],
      offset: limit
    }
  end

  def contact_params
    params.require(:contact).permit(:email, :message, :subject)
  end

  def categories_list
    faq_json_file = File.read(File.expand_path("#{Rails.root}/public/faq.json", __FILE__))

    @categories = JSON.parse(faq_json_file).to_a
  end
end
