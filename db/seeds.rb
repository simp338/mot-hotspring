require 'json'
require 'open-uri'

uri = 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024?format=json&applicationId='
results = JSON.parse open(uri).read, {symbolize_names: true}

prefecture_id = 0
city_id = 0
district_id = 0

MODE =  :cities
MODE_TEST = true

case MODE
  when :prefectures then
    results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
      prefecture_id += 1
      #prefecturesのコードと都道府県名を出力
      p "prefecture_id: "+prefecture_id.to_s if MODE_TEST == true
      p "prefecture_code: "+result[:middleClass][0][:middleClassCode]
      p "prefecture_name: "+result[:middleClass][0][:middleClassName]
    end
  when :cities then
    results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
      #citiesのコードと都道府県名を出力
      prefecture_id += 1
      result[:middleClass][1][:smallClasses].each do |smallClass|
        city_id += 1
        p "city_id: "+city_id.to_s if MODE_TEST == true
        p "prefecture_id: "+prefecture_id.to_s
        p "city_code: "+smallClass[:smallClass][0][:smallClassCode]
        p "city_name: "+smallClass[:smallClass][0][:smallClassName]
      end
    end
  when :districts then
    results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
      prefecture_id += 1
      result[:middleClass][1][:smallClasses].each do |smallClass|
        city_id += 1
        #distinctsのコードと都道府県名を出力
        begin
          smallClass[:smallClass][1][:detailClasses].each do |detailClass|
          district_id += 1
            p "district_id: "+district_id.to_s if MODE_TEST == true
            p "prefecture_id: "+prefecture_id.to_s
            p "city_id: "+city_id.to_s
            p "district_code: "+detailClass[:detailClass][:detailClassCode]
            p "district_name: "+detailClass[:detailClass][:detailClassName]
          end
        rescue NoMethodError
          next
        end
      end
    end
  else
    "MODE isn't match!"
end