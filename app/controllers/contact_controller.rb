class ContactController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      flash[:notice] = "Your message has successfully sent out."
      redirect_to contact_path
    else
      # Handling error messages
      errors = @contact.errors.messages
      msg_errors = []

      errors.each do |key, values|
        msg_errors << "#{key.capitalize} #{values[0]}"
      end

      flash[:errors] = msg_errors.flatten
      redirect_to contact_path
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :message, :subject)
  end
end
