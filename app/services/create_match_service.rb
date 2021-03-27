class CreateMatchService
  def initialize(person)
    @person = person
    @id = person.id
    @my_interests = person.interests.map(&:title)
  end

  def call
    ppl = Person.where.not(id: 1)
                .includes(:interests, :meetings)
                .select { |p| (p.meetings
                                .to_a
                                .sort_by(&:created_at)
                                &.last
                                &.created_at || 2.days.ago) < 1.day.ago }
    arr = []
    ppl.find_each do |person|
      jac_sim = jaccard_similarity(@my_interests, person.interests.map(&:title))

      arr.push(
        {
          id => person.id,
          val => jac_sim
        }
      )
    end

    arr.sort_by { |k| k[jac_sim] }
  end

  def jaccard_similarity(a, b)
    intersection = a.intersection(b).length
    union = a.union(b).length

    return 0 if union.zero?

    intersection.to_f / union
  end
end
