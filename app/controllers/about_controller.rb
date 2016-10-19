require 'json'
require 'open-uri'

class AboutController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def index
    @contact = Contact.new
    @tab = params[:tab]
    @tab = 'who-we-are' unless @tab.present?

    faq_json_file = File.read(File.expand_path("#{Rails.root}/public/faq.json", __FILE__))

    @categories = JSON.parse(faq_json_file).to_a
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

  def contact_params
    params.require(:contact).permit(:email, :message, :subject)
  end
end
