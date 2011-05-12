class UserMailer < ActionMailer::Base
  
  def register(user, domain, sent_at = Time.now)
    recipients  user.email
    subject     'Welcome to YourGarageOnline.com!'
    body        :user => user, :domain => domain
    from        'webmaster@yourgarageonline.com'
    sent_on     sent_at

  end
  
end
