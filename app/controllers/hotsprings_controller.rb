class HotspringsController < ApplicationController
  before_action :require_user_logged_in, only: [:new]

  def new
    uri = URI.parse(hotelNo_params)
    json = Net::HTTP.get(uri)
    @result = JSON.parse(json, {symbolize_names: true})
  end
  
  def index

    if params["/hotsprings"].present?
      uri = URI.parse(search_params)
      json = Net::HTTP.get(uri)
      results = JSON.parse(json, {symbolize_names: true})
      @results = results[:hotels]

      @prefecture_options = Prefecture.all
      @city_options = City.where(prefecture_id: params["/hotsprings"][:prefecture])
      @district_options = District.where(city_id: params["/hotsprings"][:city])
      
      @seleceted_prefecture = params["/hotsprings"][:prefecture]
      @seleceted_city = params["/hotsprings"][:city]
      @seleceted_district = params["/hotsprings"][:district]
      @selected_squeezeCondition = params["/hotsprings"][:squeezeCondition]
    else
      @prefecture_options = Prefecture.all
      @city_options = []
      @district_options = []
      
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
  
  def search_cities
    @prefecture = Prefecture.find(params[:prefecture_id])
    @cities = @prefecture.cities
    @districts = @cities.first.districts
    render 'hotsprings/ajax/search_cities'
  end
  
  def search_districts
    @city = City.find(params[:cities_id])
    @districts = @city.districts
    render 'hotsprings/ajax/search_districts'
  end
  
  private
  
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
