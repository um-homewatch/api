require "rails_helper"

describe ScenariosController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #index" do
    it "returns the scenarios of a home" do
      scenarios = create_list(:scenario, 3, home: home)
      json = serialize_to_json(scenarios)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      create_list(:scenario, 3, home: other_home)

      authenticate(home.user)
      get :index, params: { home_id: other_home.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a scenario from a home" do
      scenario = create(:scenario, home: home)
      json = serialize_to_json(scenario)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: scenario.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      scenario = create(:scenario, home: other_home)

      authenticate(home.user)
      get :show, params: { id: scenario.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user scenario" do
      scenario_params = attributes_for(:scenario, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, scenario: scenario_params }
      end.to change { home.scenarios.count }.by(1)
    end

    it "returns the created resource" do
      scenario_params = attributes_for(:scenario)

      authenticate(home.user)
      post :create, params: { home_id: home.id, scenario: scenario_params }

      expect(parsed_response[:name]).to eq(scenario_params[:name])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      scenario_params = attributes_for(:scenario)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, scenario: scenario_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT #update" do
    it "updates the info of a scenario" do
      scenario = create(:scenario, home: home)
      scenario_params = attributes_for(:scenario)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: scenario.id, scenario: scenario_params }
      scenario.reload

      expect(scenario.name).to eq(scenario_params[:name])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      scenario = create(:scenario, home: other_home)
      scenario_params = attributes_for(:scenario)

      authenticate(home.user)
      put :update, params: { home_id: other_home.id, id: scenario.id, scenario: scenario_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested scenario" do
      scenario = create(:scenario, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { home_id: home.id, id: scenario.id }
      end.to change { home.scenarios.count }.by(-1)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      scenario = create(:scenario, home: other_home)

      authenticate(home.user)
      delete :destroy, params: { home_id: other_home.id, id: scenario.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
