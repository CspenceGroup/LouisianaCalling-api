# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  email      :string
#  message    :text
#  subject    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#
class Contact < ApplicationRecord
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_presence_of :email, :subject, :message

  after_create :send_contact_email_to_supporter

  private

  # Send email to Support team
  def send_contact_email_to_supporter
    UserMailer.contact_us(self).deliver_now
  end
end
