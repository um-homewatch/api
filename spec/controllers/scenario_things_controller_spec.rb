require "rails_helper"

describe ScenarioThingsController, type: :controller do
  let(:scenario) { create(:scenario) }

  describe "GET #index" do
    it "returns the scenarios of a home" do
      scenario_things = create_list(:scenario_light, 3, scenario: scenario)
      json = serialize_to_json(scenario_things)

      authenticate(scenario.home.user)
      get :index, params: { home_id: scenario.home.id, scenario_id: scenario.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      create_list(:scenario_light, 3, scenario: other_scenario)

      authenticate(scenario.home.user)
      get :index, params: { home_id: other_scenario.home.id, scenario_id: scenario.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a scenario from a home" do
      scenario_thing = create(:scenario_light, scenario: scenario)
      json = serialize_to_json(scenario_thing)

      authenticate(scenario.home.user)
      get :show, params: { home_id: scenario.home.id, scenario_id: scenario.id, id: scenario_thing.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      scenario_thing = create(:scenario_light, scenario: other_scenario)

      authenticate(scenario.home.user)
      get :index, params: { home_id: other_scenario.home.id, scenario_id: scenario.id, id: scenario_thing.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user scenario" do
      thing = create(:light)
      scenario_thing_params = attributes_for(:scenario_light).merge(thing_id: thing.id)

      authenticate(scenario.home.user)

      expect do
        post :create, params: { home_id: scenario.home.id, scenario_id: scenario.id, scenario_thing: scenario_thing_params }
      end.to change { ScenarioThing.count }.by(1)
    end

    it "returns the created resource" do
      thing = create(:light)
      scenario_thing_params = attributes_for(:scenario_light).merge(thing_id: thing.id)

      authenticate(scenario.home.user)
      post :create, params: { home_id: scenario.home.id, scenario_id: scenario.id, scenario_thing: scenario_thing_params }

      expect(parsed_response[:status]).to eq(scenario_thing_params[:status])
      expect(parsed_response[:thing][:id]).to eq(thing.id)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      thing = create(:light)
      scenario_thing_params = attributes_for(:scenario_light).merge(thing_id: thing.id)

      authenticate(scenario.home.user)
      post :create, params: { home_id: scenario.home.id, scenario_id: other_scenario.id, scenario_thing: scenario_thing_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT #update" do
    it "updates the info of a scenario" do
      scenario_thing = create(:scenario_light, scenario: scenario)
      thing = create(:light)
      scenario_thing_params = attributes_for(:scenario_light).merge(thing_id: thing.id)

      authenticate(scenario.home.user)
      put :update, params: { home_id: scenario.home.id, scenario_id: scenario.id, id: scenario_thing.id, scenario_thing: scenario_thing_params }
      scenario_thing.reload

      expect(scenario_thing.thing.id).to eq(scenario_thing_params[:thing_id])
      expect(scenario_thing.status).to eq(scenario_thing_params[:status])
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      scenario_thing = create(:scenario_light, scenario: other_scenario)
      thing = create(:light)
      scenario_thing_params = attributes_for(:scenario_light).merge(thing_id: thing.id)

      authenticate(scenario.home.user)
      put :update, params: { home_id: scenario.home.id, scenario_id: other_scenario.id, id: scenario_thing.id, scenario_thing: scenario_thing_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested scenario" do
      scenario_thing = create(:scenario_light, scenario: scenario)

      authenticate(scenario.home.user)

      expect do
        delete :destroy, params: { home_id: scenario.home.id, scenario_id: scenario.id, id: scenario_thing.id }
      end.to change { ScenarioThing.count }.by(-1)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      create(:scenario_light, scenario: other_scenario)

      authenticate(scenario.home.user)
      delete :destroy, params: { home_id: scenario.home.id, scenario_id: other_scenario.id, id: scenario.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
