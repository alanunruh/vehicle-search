class VehiclesController < ApplicationController
  def index
    @vehicles = Vehicle.all
  end

  def create
    if Vehicle.where(vin: vin_param).exists?
      flash[:error] = 'Vehicle already exists'
    else
      VehicleVINLookupService.new(vin_param).perform
      flash[:success] = 'Vehicle successfully saved'
    end
    redirect_to root_path
  end

  private

  def vehicle_params
    params.require(:vehicle).permit(:vin)
  end

  def vin_param
    vehicle_params[:vin]
  end
end
