class SendSmsService
  def initialize(receiver:, content:)
    @receiver = receiver
    @content = content
  end

  def call
    return if sender == @receiver

    Twilio::REST::Client.new(account, token).messages.create(
      body: @content,
      from: sender,
      to: @receiver
    )
  end

  def sender
    ENV['TWILIO_SENDER']
  end

  def account
    ENV['TWILIO_ACCOUNT']
  end

  def token
    ENV['TWILIO_TOKEN']
  end
end
