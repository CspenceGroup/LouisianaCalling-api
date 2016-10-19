require 'mandrill'

class BaseMandrillMailer < ActionMailer::Base
  default(
    from: 'Louisiana Calling <noreply@example.com>'
  )

  private

  def send_mail(email, subject, body)
    mail(to: email, subject: subject, body: body, content_type: 'text/html')
  end

  def send_mail_reply_to(email, email_cc, subject, body)
    mail(to: email, reply_to: email_cc, subject: subject, body: body, content_type: 'text/html')
  end

  def mandrill_template(template_name, attributes)
    mandrill = Mandrill::API.new(ENV['SMTP_PASSWORD'])

    merge_vars = attributes.map do |key, value|
      { name: key, content: value }
    end

    mandrill.templates.render(template_name, [], merge_vars)['html']
  end
end
