class SurveysController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    survey_service = HandleSurveyResponseService.new(params)
    survey_service.call

    head 200
  end
end
