require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "group_notice" do
    mail = UserMailer.group_notice
    assert_equal "Group notice", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
