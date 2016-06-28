json.array!(@studies) do |study|
  json.extract! study, :id, :height, :weight, :likes
  json.url study_url(study, format: :json)
end
