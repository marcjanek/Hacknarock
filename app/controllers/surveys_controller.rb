class SurveysController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    survey_service = HandleSurveyResponseService.new(params)
    survey_service.call

    head 200
  end

  def show
    hashids = Hashids.new(ENV['HASHIDS_SALT'], 12, ('a'..'z').to_a.join)
    id = hashids.decode(params[:id])

    Person.find(id).destroy
  end
end
