class Api::V1::ReportsController < ApplicationController
  def monthly
    render json: MonthlyReport.new(user: current_user, month: parsed_month).call
  rescue ArgumentError
    render json: { error: 'Invalid month format. Use YYYY-MM.' }, status: :bad_request
  end

  private

  def parsed_month
    return Date.current.beginning_of_month if params[:month].blank?

    Date.strptime(params[:month], '%Y-%m')
  end
end
