require 'json'
require 'open-uri'

uri = 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024?format=json&applicationId='+ENV["RAKUTEN_APPLICATION_ID"]
results = JSON.parse open(uri).read, {symbolize_names: true}

MODE =  :districts

case MODE
  when :prefectures
    results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
      Prefecture.find_or_create_by(
        code: result[:middleClass][0][:middleClassCode],
        name: result[:middleClass][0][:middleClassName],
        )
    end
  when :cities
    results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
      prefecture = Prefecture.find_by(code: result[:middleClass][0][:middleClassCode])
      result[:middleClass][1][:smallClasses].each do |smallClass|
        prefecture.cities.find_or_create_by(
          code: smallClass[:smallClass][0][:smallClassCode],
          name: smallClass[:smallClass][0][:smallClassName],
          )
      end
    end
  when :districts
    results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
      prefecture = Prefecture.find_by(code: result[:middleClass][0][:middleClassCode])
      result[:middleClass][1][:smallClasses].each do |smallClass|
        city = City.find_by(prefecture_id: prefecture.id, code: smallClass[:smallClass][0][:smallClassCode])
        begin
          smallClass[:smallClass][1][:detailClasses].each do |detailClass|
            city.districts.find_or_create_by(
              code: detailClass[:detailClass][:detailClassCode],
              name: detailClass[:detailClass][:detailClassName],
              prefecture_id: prefecture.id,
              )
          end
        rescue NoMethodError
          next
        end
      end
    end
  else
    "MODE isn't match!"
end