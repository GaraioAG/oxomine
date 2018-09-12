class HealthchecksController < ApplicationController
  skip_before_action :check_if_login_required

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
