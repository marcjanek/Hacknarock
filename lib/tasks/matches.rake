namespace :matches do
  desc "Generates new matches"
  task generate: :environment do
    Person.find_each do |person|
      # puts person.inspect
      next if (person.meetings.order(date: :desc).last&.date || 1.day.ago) > Time.now

      service = CreateMatchService.new(person)

      service.call

      next if service.results.count.zero?

      service.results << person

      meeting_service = CreateMeetingService.new(service.date)
      meeting_service.call

      service.results.each do |matched_person|
        matched_person.meetings << meeting_service.meeting

        mail_service = PrepareMailService.new(url: meeting_service.url,
                                              people: service.results.reject { |m| m == matched_person },
                                              date: service.date,
                                              id: matched_person.id)

        SendMailService.new(
          receiver: matched_person.email,
          subject: 'Przygotowaliśmy spotkanie specjalnie dla Ciebie',
          content: mail_service.call
        ).call

        next unless matched_person.phone.present?

        SendSmsService.new(
          receiver: matched_person.phone,
          content: "Przygotowalismy spotkanie #{service.date.strftime('%d-%m-%Y %H:%M')}: #{meeting_service.url}"
        ).call
      end
    end
  end
end
