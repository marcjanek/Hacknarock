class HandleSurveyResponseService
  FIELDS = {
    'd566770d2197a78b' => :name,
    '567a2e02f18fd3e2' => :age,
    'd6b6724b54f245f8' => :description,
    '7ef411a1-ad96-467c-9f30-4863052ae2d9' => :interests,
    '4003964c-1dc5-456a-8217-9973a51567c1' => :day,
    'd10bf12b-d17d-4513-9d4b-418e9d4a2884' => :hour,
    'b55c04c8-ed3d-423a-bdc4-681d77200420' => :group_size,
    '7b7d54de-609c-4159-a711-31e5734f7aff' => :email,
    '98a5bec4-cf4d-48d6-b80e-a410ba842220' => :phone,
    'c83363ed-5566-453e-8b4f-6764fe5f5b77' => :length
  }

  def initialize(params)
    @params = params
  end

  def call
    response = {}

    @params.dig('form_response', 'answers').each do |param|
      response[FIELDS[param['field']['ref']]] =
        (param[param['type']].is_a?(ActionController::Parameters) ? (param[param['type']]['label'] ||
                                                                      param[param['type']]['labels']) : param[param['type']])
    end

    create_person(response)
  end

  private

  def create_person(params)
    person = Person.create(
      name: params[:name],
      age: params[:age],
      description: params[:description],
      day: params[:day],
      hour: params[:hour],
      group_size: params[:group_size].match(/(\d(?=\+)|(?<=-)\d|\A\d\z)/).to_s.to_i,
      email: params[:email],
      phone: params[:phone],
      length: params[:length]
    )

    return unless person.persisted?

    params[:interests].each do |interest|
      person.interests << Interest.find_by(title: interest)
    end
  end
end
