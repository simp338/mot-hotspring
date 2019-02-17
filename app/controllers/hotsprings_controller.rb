class HotspringsController < ApplicationController
  before_action :require_user_logged_in, only: [:new]

  def new
  end
  
  def index
    @hotsprings = []
    @hotspring_details = []
    @aboutBath_hashes = {}
    
    if params["/hotsprings"].present?
      uri = URI.parse(search_params)
      json = Net::HTTP.get(uri)
      results = JSON.parse(json, {symbolize_names: true})
      
      if results[:hotels].present?
        results[:hotels].each do |result|
          hotspring = Hotspring.find_or_initialize_by(read(result))
          @hotsprings << hotspring
          bath_infos = []
          read_bath(result).each do |bath_info|
            if bath_info[:bathType]
              bath_infos << bath_info[:bathType]
            end
            abouthBath_hash = { hotspring[:code] => bath_infos }
            @aboutBath_hashes.merge!(abouthBath_hash)
          end
        end
      else
        @noresults = "登録された施設はありません。"
      end
      
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
      @selected_squeezeCondition = :onsen
    end
  end

  def edit
  end

  def destroy
  end

  def update
  end

  def show
    uri = URI.parse(hotelNo_search(params[:code]))
    json = Net::HTTP.get(uri)
    result = JSON.parse(json, {symbolize_names: true})
    if result[:hotels].present?
      @hotspring = Hotspring.find_or_initialize_by(read(result[:hotels].first))
      @hotspring_details = read_all(result[:hotels].first)
      
      @hotspring_aboutBath = []
      read_bath(result[:hotels].first).each do |bath_info|
        if bath_info[:bathType]
          @hotspring_aboutBath << bath_info[:bathType]
        end
      end
    else
      @noresults = "登録された施設はありません。"
      redirect_back(fallback_location: root_path)
    end      
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
  
end
