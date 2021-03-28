class CreateMatchService
  attr_accessor :results, :date

  DAY_MAPPINGS = {
    'Poniedziałek' => 1,
    'Wtorek' => 2,
    'Środa' => 3,
    'Czwartek' => 4,
    'Piątek' => 5,
    'Sobota' => 6,
    'Niedziela' => 0
  }

  def initialize(person)
    @person = person
    @id = person.id
    @my_interests = person.interests.map(&:title)
  end

  def call
    @results = []
    ppl = Person.where.not(id: @id)
                .where(group_size: @person.group_size)
                .includes(:interests, :meetings)
                .select { |p| (p.meetings
                                .to_a
                                .sort_by(&:created_at)
                                &.last
                                &.created_at || 2.days.ago) < 1.day.ago }

    res = 0.upto(@person.length.to_i).map do |i|
      ppl_new = []

      ppl.each do |p|
        if p.day == @person.day && (@person.hour.to_i + i).between?(p.hour.to_i, p.hour.to_i + p.length.to_i)
          ppl_new << p
        end
      end

      {
        delay: i,
        people: find_matches(ppl_new)
      }
    end

    res.map! do |r|
      {
        delay: r[:delay],
        people: r[:people].reject { |k| k[:val] == 0.0 }
                          .sort_by { |k| k[:val] }
                          .last(@person.group_size.to_i)
      }
    end

    res.reject! { |k| k[:people].empty? }

    return false if res.empty?

    result = res.max_by { |r| r[:people].sum { |k| k[:val] } }

    @date = parse_date(@person, result[:delay])

    @results = result[:people].map { |k| Person.find(k[:id]) }
  end

  private

  def find_matches(ppl)
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

    arr
  end

  def jaccard_similarity(a, b)
    intersection = a.intersection(b).length
    union = a.union(b).length

    return 0 if union.zero?

    intersection.to_f / union
  end

  def parse_date(prs, interval)
    1.upto(7) do |days|
      tested_date = Time.new + days.day

      if tested_date.wday == DAY_MAPPINGS[prs.day]
        return Time.new(tested_date.year,
                        tested_date.month,
                        tested_date.day,
                        (prs.hour.to_i + interval) % 24,
                        0)
      end
    end
  end
end
