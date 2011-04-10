class UserMailer < ActionMailer::Base
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Admin <no-reply@evening-sky-672.com>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
end