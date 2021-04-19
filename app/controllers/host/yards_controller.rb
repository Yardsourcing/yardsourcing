# require "services/y_s_engine_service"
class Host::YardsController < ApplicationController
  before_action :set_purposes, only: [:new, :create]
  def new
  end
  def create
    params[:host_id] = current_user.id
    params[:email] = current_user.email
    yard = EngineService.create_yard(yard_params)
    if yard.include?(:error)
      flash[:error] = yard[:error]
      render :new, obj: @purposes
    else
      redirect_to yard_path(yard[:data][:id])
    end
  end
  private
  def yard_params
    params.permit(:host_id, :email, :name, :description, :availability, :payment,
                  :price, :street_address, :city, :state, :zipcode, :photo_url_1,
                  :photo_url_2, :photo_url_3, purposes: [])
  end

  def set_purposes
    info = EngineService.all_purposes
    @purposes = info[:data].map do |obj_info|
      OpenStruct.new({ id: obj_info[:id],
                       name: obj_info[:attributes][:name].titleize})
    end
  end
end
