class UserMailer < BaseMandrillMailer

  def contact_us(contact)
    @contact = contact
    merge_vars = {
      'EMAIL' => @contact.email,
      'MESSAGE' => @contact.message
    }
    body = mandrill_template('contact_us', merge_vars)
    subject = "Contact Message from #{@contact.email}: #{@contact.subject}"

    send_mail_reply_to(ENV['SUPPORTER_EMAIL'], @contact.email, subject, body)
  end
end
