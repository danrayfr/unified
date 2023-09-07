require "test_helper"

class QualityMailerTest < ActionMailer::TestCase
  test "qa_notification" do
    mail = QualityMailer.qa_notification
    assert_equal "Qa notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
