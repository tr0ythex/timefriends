class Api::V1::BgPacksController < ApplicationController
  before_action :authenticate_with_token!, only: :index
  
  def index
    bg_packs = current_user.bg_packs.where(name: params[:name], device_type: params[:device_type])
    
    # if params[:name] == "all"
    #   if params[:device_type]
    #     bg_packs = bg_packs.where(device_type: params[:device_type])
    #   end
    # else
    #   bg_packs = bg_packs.where(name: params[:name])
    # end
    
    render json: bg_packs.find(1).backgrounds
  end
  
end