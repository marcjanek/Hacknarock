class CreateMeetingService
  attr_accessor :uuid, :date, :meeting

  def initialize(date)
    @date = date
    @uuid = SecureRandom.uuid
  end

  def call
    @meeting = Meeting.create(
      date: @date,
      uuid: @uuid
    )
  end

  def url
    "https://meet.jit.si/#{jitsi_scope}/#{@uuid}"
  end

  private

  def jitsi_scope
    ENV['JITSI_SCOPE']
  end
end
