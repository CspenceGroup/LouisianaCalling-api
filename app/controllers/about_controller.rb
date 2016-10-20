require 'json'
require 'open-uri'

class AboutController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  before_filter :categories_list, only: [:index, :create]

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

    categories = categories_list
    key = params[:key]

    categories.each do |category|
      questions = category['questions'].to_a

      questions.each do |question|
        unless question['content'].include?(key) || question['answer'].include?(key)
          next
        end
        question = {
          category: category['name'],
          content: question['content'],
          answer: question['answer']
        }
        results.push(question)
      end
    end
    puts 'count', results.count
    {
      count: results.count,
      objects: results
    }
  end

  def contact_params
    params.require(:contact).permit(:email, :message, :subject)
  end

  def categories_list
    faq_json_file =
      if Rails.env == 'development'
        "#{Rails.root}/public/faq.json"
      else
        "#{Rails.root}/drkiq/public/faq.json"
      end
    faq_json = File.read(File.expand_path(faq_json_file, __FILE__))

    @categories = JSON.parse(faq_json).to_a
  end
end
