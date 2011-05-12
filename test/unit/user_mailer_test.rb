require 'test_helper'

class UserMailerTest < ActiveSupport::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    @user = users(:jared)
  end
  
  def test_register
    response = UserMailer.create_register(@user, '')
    
    assert_equal("Welcome to YourGarageOnline.com!", response.subject)
    assert_equal("jared@example.com", response.to[0])
    assert_match(/Dear jared/, response.body)
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/user_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
