Rails.application.configure do
  config.action_mailer.smtp_settings = {
    :address   => ENV.fetch("SMTP_ADDRESS"),
    :port      => 587,
    :enable_starttls_auto => true,
    :user_name => ENV.fetch("SMTP_USERNAME"),
    :password  => ENV.fetch("SMTP_PASSWORD"),
    :authentication => :plain,
    :domain => ENV.fetch("SMTP_DOMAIN")
  }
  config.action_mailer.default_url_options = { host: ENV["SMTP_DOMAIN"] }
end
