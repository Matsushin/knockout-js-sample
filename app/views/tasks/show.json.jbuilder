json.extract! @task, :id, :title, :body, :created_at
json.updated_at l @task.updated_at.to_date
