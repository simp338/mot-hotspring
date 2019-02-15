class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
    
  def search_params
    # binding.pry
    uri = URI("https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426")
    uri.query = {
      largeClassCode: :japan,
      middleClassCode: Prefecture.find(params["/hotsprings"][:prefecture]).code,  #"tokyo" 
      smallClassCode: City.find(params["/hotsprings"][:city]).code,  #"tokyo"
      detailClassCode: 
        if params["/hotsprings"][:district].present?
          District.find(params["/hotsprings"][:district]).code
        else
          nil
        end,  #"A"
      format: 'json',
      applicationId: ENV['RAKUTEN_APPLICATION_ID'],
      squeezeCondition: params["/hotsprings"][:squeezeCondition],
    }.to_param

    uri.to_s
  end
  
  def read(result)
    code = result[:hotel][0][:hotelBasicInfo][:hotelNo]
    name = result[:hotel][0][:hotelBasicInfo][:hotelName]
    
    {
      code: code,
      name: name,
    }
  end
end