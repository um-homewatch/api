require "rails_helper"

describe ScenarioThingsController, type: :controller do
  let(:scenario) { create(:scenario) }

  describe "GET #index" do
    it "returns the scenarios of a home" do
      scenario_things = create_list(:scenario_thing, 3, scenario: scenario)
      json = serialize_to_json(scenario_things)

      authenticate(scenario.home.user)
      get :index, params: { scenario_id: scenario.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      create_list(:scenario_thing, 3, scenario: other_scenario)

      authenticate(scenario.home.user)
      get :index, params: { scenario_id: other_scenario.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a scenario from a home" do
      scenario_thing = create(:scenario_thing, scenario: scenario)
      json = serialize_to_json(scenario_thing)

      authenticate(scenario.home.user)
      get :show, params: { scenario_id: scenario.id, id: scenario_thing.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      scenario_thing = create(:scenario_thing, scenario: other_scenario)

      authenticate(scenario.home.user)
      get :index, params: { scenario_id: other_scenario.id, id: scenario_thing.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user scenario" do
      thing = create(:light, home: scenario.home)
      scenario_thing_params = attributes_with_foreign_keys(:scenario_thing, thing: thing)

      authenticate(scenario.home.user)

      expect do
        post :create, params: { scenario_id: scenario.id, scenario_thing: scenario_thing_params }
      end.to change { ScenarioThing.count }.by(1)
    end

    it "returns the created resource" do
      thing = create(:light, home: scenario.home)
      scenario_thing_params = attributes_with_foreign_keys(:scenario_thing, thing: thing)

      authenticate(scenario.home.user)
      post :create, params: { scenario_id: scenario.id, scenario_thing: scenario_thing_params }

      expect(parsed_response[:status]).to eq(scenario_thing_params[:status])
      expect(parsed_response[:thing][:id]).to eq(thing.id)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      thing = create(:light, home: other_scenario.home)
      scenario_thing_params = attributes_with_foreign_keys(:scenario_thing, thing: thing)

      authenticate(scenario.home.user)
      post :create, params: { scenario_id: other_scenario.id, scenario_thing: scenario_thing_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT #update" do
    it "updates the info of a scenario" do
      scenario_thing = create(:scenario_thing, scenario: scenario)
      thing = create(:light, home: scenario.home)
      scenario_thing_params = attributes_with_foreign_keys(:scenario_thing, thing: thing)

      authenticate(scenario.home.user)
      put :update, params: { scenario_id: scenario.id, id: scenario_thing.id, scenario_thing: scenario_thing_params }
      scenario_thing.reload

      expect(scenario_thing.thing.id).to eq(scenario_thing_params[:thing_id])
      expect(scenario_thing.status).to eq(scenario_thing_params[:status])
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      scenario_thing = create(:scenario_thing, scenario: other_scenario)
      thing = create(:light, home: other_scenario.home)
      scenario_thing_params = attributes_with_foreign_keys(:scenario_thing, thing: thing)

      authenticate(scenario.home.user)
      put :update, params: { scenario_id: other_scenario.id, id: scenario_thing.id, scenario_thing: scenario_thing_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested scenario" do
      scenario_thing = create(:scenario_thing, scenario: scenario)

      authenticate(scenario.home.user)

      expect do
        delete :destroy, params: { scenario_id: scenario.id, id: scenario_thing.id }
      end.to change { ScenarioThing.count }.by(-1)
    end

    it "returns a not found status code" do
      other_scenario = create(:scenario)
      create(:scenario_thing, scenario: other_scenario)

      authenticate(scenario.home.user)
      delete :destroy, params: { scenario_id: other_scenario.id, id: scenario.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
