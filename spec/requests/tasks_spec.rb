require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  describe "GET /tasks/new" do
    it "returns http success" do
      get "/tasks/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /tasks" do
    it "creates a task and redirects" do
      post "/tasks", params: { task: { name: "Test task", interval_type: "weekly" } }
      expect(response).to have_http_status(:redirect)
      expect(Task.count).to eq(1)
    end
  end

  describe "GET /tasks" do
    it "returns http success" do
      get "/tasks"
      expect(response).to have_http_status(:success)
    end
  end

end
