class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def require_user_logged_in
    unless logged_in?
      flash[:warning] = "ログインが必要です。"
      redirect_to login_url
    end
  end
  
  def search_params
    uri = URI("https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426")
    begin
      uri.query = {
        largeClassCode: :japan,
        middleClassCode: Prefecture.find_by(id: params["/hotsprings"][:prefecture]).code,
        smallClassCode: City.find_by(id: params["/hotsprings"][:city]).code,
        detailClassCode: 
          if params["/hotsprings"][:district].present?
            District.find_by(id: params["/hotsprings"][:district]).code
          else
            nil
          end,
        format: 'json',
        applicationId: ENV['RAKUTEN_APPLICATION_ID'],
        squeezeCondition: params["/hotsprings"][:squeezeCondition],
        responseType: 'large',
      }.to_param
    rescue
      redirect_back(fallback_location: root_path)
    end
    uri.to_s
  end
  
  def read(result)
    basic_info = result[:hotel][0][:hotelBasicInfo]
    
    code = basic_info[:hotelNo]
    name = basic_info[:hotelName]
    url = basic_info[:hotelInformationUrl]
    image_url = basic_info[:hotelImageUrl]
    
    {
      code: code,
      name: name,
      url: url,
      image_url: image_url,
    }
  end
  
  def read_bath(result)
    result[:hotel][3][:hotelFacilitiesInfo][:aboutBath]
  end
    
  def read_all(result)
    basic_info = result[:hotel][0][:hotelBasicInfo]
    
    hotelSpecial = basic_info[:hotelSpecial]
    hotelMinCharge = basic_info[:hotelMinCharge]
    postalCode	 = basic_info[:postalCode]
    address1 = basic_info[:address1]
    address2 = basic_info[:address2]
    telephoneNo = basic_info[:telephoneNo]
    access = basic_info[:access]
    parkingInformation = basic_info[:parkingInformation]
    reviewAverage = basic_info[:reviewAverage]
    
    {
      施設特色: hotelSpecial,
      最安料金: hotelMinCharge.to_s+"円〜",
      住所: "〒"+postalCode+" "+address1+address2,
      電話番号: telephoneNo,
      アクセス: access,
      駐車場情報: parkingInformation,
      楽天トラベル総合評価: reviewAverage,
    }    
  end
  
  def hotelNo_search(hotelNo)
    uri = URI("https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426")
    
    uri.query = {
      hotelNo: hotelNo,
      format: 'json',
      applicationId: ENV['RAKUTEN_APPLICATION_ID'],
      responseType: 'large',
    }.to_param

    uri.to_s
  end
end