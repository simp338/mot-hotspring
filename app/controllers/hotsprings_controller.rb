class HotspringsController < ApplicationController

  def new
    uri = URI.parse(hotelNo_params)
    json = Net::HTTP.get(uri)
    @result = JSON.parse(json, {symbolize_names: true})
  end
  
  def index
        #binding.pry

    if params["/hotsprings"].present?
      uri = URI.parse(search_params)
      json = Net::HTTP.get(uri)
      results = JSON.parse(json, {symbolize_names: true})
      @results = results[:hotels]
      @seleceted_prefecture = params["/hotsprings"][:prefecture]
      @seleceted_city = params["/hotsprings"][:city]
      @seleceted_district = params["/hotsprings"][:district]
      @selected_squeezeCondition = params["/hotsprings"][:squeezeCondition]
    else
      @seleceted_prefecture = nil
      @seleceted_city = nil
      @seleceted_district = nil
      @selected_squeezeCondition = :daiyoku
    end
  end

  def edit
  end

  def destroy
  end

  def update
  end

  def show
  end

  def create
  end
  
  private
  
  def search_params
    uri = URI("https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426")
    # binding.pry
    uri.query = {
      largeClassCode: :japan,
      middleClassCode: params["/hotsprings"][:prefecture],  #"tokyo" 
      smallClassCode: params["/hotsprings"][:city],  #"tokyo"
      detailClassCode: params["/hotsprings"][:district],  #"A"
      format: 'json',
      applicationId: ENV['RAKUTEN_APPLICATION_ID'],
      squeezeCondition: params["/hotsprings"][:squeezeCondition],
    }.to_param

    uri.to_s
  end
  
  def hotelNo_params
    uri = URI("https://app.rakuten.co.jp/services/api/Travel/SimpleHotelSearch/20170426")
    
    uri.query = {
      hotelNo: params[:hotelNo],  #ex => "41071"
      format: 'json',
      applicationId: ENV['RAKUTEN_APPLICATION_ID'],
    }.to_param

    uri.to_s
  end
end
