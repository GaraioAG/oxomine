class HealthchecksController < ApplicationController
  def healthz
    # TODO: Add more checks!

    status = 'success'

    begin
      User.count
    rescue
      status = 'DB connection not possible'
    end

    render json: { status: status }, status: status == 'success' ? :ok : :internal_server_error
  end
end
