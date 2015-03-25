json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :body
  json.updated_at l task.updated_at.to_date
  json.url task_url(task, format: :json)
end
