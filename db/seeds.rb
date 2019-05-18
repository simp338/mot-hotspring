# require 'json'
# require 'open-uri'

# uri = 'https://app.rakuten.co.jp/services/api/Travel/GetAreaClass/20131024?format=json&applicationId='+ENV["RAKUTEN_APPLICATION_ID"]
# results = JSON.parse open(uri).read, {symbolize_names: true}

# modes = [:prefectures, :cities, :districts]

# modes.each do |mode|
#   case mode
#     when :prefectures
#       results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
#         Prefecture.find_or_create_by(
#           code: result[:middleClass][0][:middleClassCode],
#           name: result[:middleClass][0][:middleClassName],
#           )
#       end
#     when :cities
#       results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
#         prefecture = Prefecture.find_by(code: result[:middleClass][0][:middleClassCode])
#         result[:middleClass][1][:smallClasses].each do |smallClass|
#           prefecture.cities.find_or_create_by(
#             code: smallClass[:smallClass][0][:smallClassCode],
#             name: smallClass[:smallClass][0][:smallClassName],
#             )
#         end
#       end
#     when :districts
#       results [:areaClasses][:largeClasses][0][:largeClass][1][:middleClasses].each do |result|
#         prefecture = Prefecture.find_by(code: result[:middleClass][0][:middleClassCode])
#         result[:middleClass][1][:smallClasses].each do |smallClass|
#           city = City.find_by(prefecture_id: prefecture.id, code: smallClass[:smallClass][0][:smallClassCode])
#           begin
#             smallClass[:smallClass][1][:detailClasses].each do |detailClass|
#               city.districts.find_or_create_by(
#                 code: detailClass[:detailClass][:detailClassCode],
#                 name: detailClass[:detailClass][:detailClassName],
#                 prefecture_id: prefecture.id,
#                 )
#             end
#           rescue
#             next
#           end
#         end
#       end
#     else
#       "MODE isn't match!"
#   end
# end

# # userモデルにデータ追加
# ("a".."z").each do |name|
#   User.find_or_create_by!(email: "#{name}@#{name}.com") do |user|
#     user.name = "#{name}"
#     user.email = "#{name}@#{name}.com"
#     user.password = "#{name}"
#     user.password_confirmation = "#{name}"
#   end
# end

# reviewモデルにデータ追加
(1..5).each do |attempt|
  ("a".."z").each do |name|
    user = User.find_by(email: "#{name}@#{name}.com")
      user.reviews.create(
      hotspring_id: 1,
      title: "#{name}のタイトル#{attempt}",
      comment: "#{name}のコメント#{attempt}；" * 10,
    )
  end
end
