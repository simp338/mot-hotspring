class RelationshipsController < ApplicationController
  def create
    @hotspring = Hotspring.find_or_initialize_by(code: params[:hotspring_code])
    
    unless @hotspring.persisted?
      uri = URI.parse(search_params)
      json = Net::HTTP.get(uri)
      results = JSON.parse(json, {symbolize_names: true})
      @hotspring = Hotspring.new(results.first)
      @hotspring.save
    end
    
    if params[:type] == "Wannago"
      current_user.wannago(@hotspring)
      flash[:success] = "「行きたい」に保存しました。"
    end
    
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @hotspring = Hotspring.find(params[:id])
    
    if params[:type] == "Wannago"
      current_user.unwannago(@hotspring)
      flash[:success] = "「行きたい」を解除しました。"
    end

    redirect_back(fallback_location: root_path)
  end
end
