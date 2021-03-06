require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  render_views

  describe "GET #home" do
    it "responds with status code 200" do
      get :home
      expect(response).to have_http_status(:ok)
    end

    it "renders template" do
      get :home
      expect(response).to render_template :home
    end
  end

  describe "GET #thanks_online" do
    it "responds with status code 200" do
      get :thanks_online
      expect(response).to have_http_status(:ok)
    end

    it "render template" do
      get :thanks_online
      expect(response).to render_template :thanks_online
    end
  end

  describe "GET #thanks_bootcamp" do
    it "responds with status code 200" do
      get :thanks_bootcamp
      expect(response).to have_http_status(:ok)
    end

    it "render template" do
      get :thanks_bootcamp
      expect(response).to render_template :thanks_bootcamp
    end
  end

  describe "GET #handbook" do
    it "shows content" do
      fake_content = "fake content"
      expect_any_instance_of(Octokit::Client).to receive(:contents).and_return(fake_content)
      get :handbook
      expect(response.body).to have_content fake_content
    end
  end
end
