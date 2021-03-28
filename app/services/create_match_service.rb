class CreateMatchService
  attr_accessor :results, :date

  def initialize(person)
    @person = person
    @id = person.id
    @my_interests = person.interests.map(&:title)
  end

  def call
    @date = parse_date

    ppl = Person.where.not(id: @id)
                .where(group_size: @person.group_size)
                .includes(:interests, :meetings)
                .select { |p| (p.meetings
                                .to_a
                                .sort_by(&:created_at)
                                &.last
                                &.created_at || 2.days.ago) < 1.day.ago }
    arr = []
    ppl.each do |person|
      jac_sim = jaccard_similarity(@my_interests, person.interests.map(&:title))

      arr.push(
        {
          id: person.id,
          val: jac_sim.to_f / (1 + ((@person.age - person.age).abs.to_f / 10))
        }
      )
    end

    @results = arr.sort_by { |k| k[:val] }
                  .reject { |k| k[:val] == 0.0 }
                  .reverse
                  .map { |k| Person.find(k[:id]) }
                  .first(@person.group_size.to_i)
  end

  private

  def jaccard_similarity(a, b)
    intersection = a.intersection(b).length
    union = a.union(b).length

    return 0 if union.zero?

    intersection.to_f / union
  end

  def parse_date
    day_mappings = {
      'Poniedziałek' => 1,
      'Wtorek' => 2,
      'Środa' => 3,
      'Czwartek' => 4,
      'Piątek' => 5,
      'Sobota' => 6,
      'Niedziela' => 0
    }

    1.upto(7) do |days|
      tested_date = Time.new + days.day

      if tested_date.wday == day_mappings[@person.day]
        return Time.new(tested_date.year,
                        tested_date.month,
                        tested_date.day,
                        @person.hour.to_i,
                        0)
      end
    end
  end
end
