class SendMailService
  def initialize(receiver:, subject:, content:)
    @receiver = receiver
    @subject = subject
    @content = content
  end

  def call
    Mailgun::Client.new(token, endpoint).send_message(
      domain,
      {
        from: sender,
        to: @receiver,
        subject: @subject,
        html: @content
      }
    )
  end

  def domain
    ENV['MAILGUN_DOMAIN']
  end

  def endpoint
    ENV['MAILGUN_ENDPOINT']
  end

  def sender
    ENV['MAILGUN_SENDER']
  end

  def token
    ENV['MAILGUN_TOKEN']
  end
end
