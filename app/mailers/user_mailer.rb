class UserMailer < BaseMandrillMailer

  def contact_us(contact)
    @contact = contact
    merge_vars = {
      'EMAIL' => @contact.email,
      'MESSAGE' => @contact.message,
      'SUBJECT' => @contact.subject
    }
    body = mandrill_template('contact_us', merge_vars)

    send_mail(ENV['SUPPORTER_EMAIL'], @contact.subject, body)
  end
end
