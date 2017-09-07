require "rails_helper"

describe Tasks::TriggeredTaskController, type: :controller do
  let(:home) { create(:home) }

  def triggered_task_params_thing(thing)
    attributes_for(
      :triggered_task,
      thing_to_compare_id: create(:motion_sensor, home: home).id,
      thing_id: thing.id,
    )
  end

  def triggered_task_params_scenario(scenario)
    attributes_for(
      :triggered_task,
      thing_to_compare_id: create(:motion_sensor, home: home).id,
      scenario_id: scenario.id,
    )
  end

  describe "GET #index" do
    it "returns the triggered tasks of a home" do
      triggered_tasks = create_list(:triggered_task, 3, home: home)
      json = serialize_to_json(triggered_tasks)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      create_list(:triggered_task, 3, home: other_home)

      authenticate(home.user)
      get :index, params: { home_id: other_home.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a triggered_task" do
      triggered_task = create(:triggered_task, home: home)
      json = serialize_to_json(triggered_task)

      authenticate(home.user)
      get :show, params: { id: triggered_task.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      triggered_task = create(:triggered_task, home: other_home)

      authenticate(home.user)
      get :show, params: { id: triggered_task.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create with thing" do
    it "creates a triggered_task" do
      thing = create(:light, home: home)
      triggered_task_params = triggered_task_params_thing(thing)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, triggered_task: triggered_task_params }
      end.to change { Tasks::TriggeredTask.count }.by(1)
    end

    it "returns the created resource" do
      thing = create(:light, home: home)
      triggered_task_params = triggered_task_params_thing(thing)

      authenticate(home.user)
      post :create, params: { home_id: home.id, triggered_task: triggered_task_params }

      expect(parsed_response[:thing][:id]).to eq(triggered_task_params[:thing_id])
      expect(parsed_response[:thing_to_compare][:id]).to eq(triggered_task_params[:thing_to_compare_id])
      expect(parsed_response[:status_to_compare]).to eq(triggered_task_params[:status_to_compare])
      expect(parsed_response[:status_to_apply]).to eq(triggered_task_params[:status_to_apply])
      expect(parsed_response[:comparator]).to eq(triggered_task_params[:comparator])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      triggered_task_params = attributes_for(:triggered_task)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, triggered_task: triggered_task_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create with scenario" do
    it "creates a triggered_task" do
      scenario = create(:scenario, home: home)
      triggered_task_params = triggered_task_params_scenario(scenario)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, triggered_task: triggered_task_params }
      end.to change { Tasks::TriggeredTask.count }.by(1)
    end

    it "returns the created resource" do
      scenario = create(:scenario, home: home)
      triggered_task_params = triggered_task_params_scenario(scenario)

      authenticate(home.user)
      post :create, params: { home_id: home.id, triggered_task: triggered_task_params }

      expect(parsed_response[:scenario][:id]).to eq(triggered_task_params[:scenario_id])
      expect(parsed_response[:thing_to_compare][:id]).to eq(triggered_task_params[:thing_to_compare_id])
      expect(parsed_response[:status_to_compare]).to eq(triggered_task_params[:status_to_compare])
      expect(parsed_response[:status_to_apply]).to eq(triggered_task_params[:status_to_apply])
      expect(parsed_response[:comparator]).to eq(triggered_task_params[:comparator])
    end
  end

  describe "PUT #update" do
    it "updates the info of a triggered_task" do
      triggered_task = create(:triggered_task, home: home)
      thing = create(:light, home: home)
      triggered_task_params = triggered_task_params_thing(thing)

      authenticate(home.user)
      put :update, params: { id: triggered_task.id, triggered_task: triggered_task_params }
      triggered_task.reload

      expect(triggered_task.thing.id).to eq(triggered_task_params[:thing_id])
      expect(triggered_task.thing_to_compare.id).to eq(triggered_task_params[:thing_to_compare_id])
      expect(triggered_task.status_to_compare).to eq(triggered_task_params[:status_to_compare])
      expect(triggered_task.status_to_apply).to eq(triggered_task_params[:status_to_apply])
      expect(triggered_task.comparator).to eq(triggered_task_params[:comparator])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      triggered_task = create(:triggered_task, home: other_home)
      triggered_task_params = attributes_for(:triggered_task)

      authenticate(home.user)
      put :update, params: { id: triggered_task.id, triggered_task: triggered_task_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested triggered_task" do
      triggered_task = create(:triggered_task, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { id: triggered_task.id }
      end.to change { Tasks::TriggeredTask.count }.by(-1)
    end

    it "destroys the associated delayed job" do
      triggered_task = create(:triggered_task, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { id: triggered_task.id }
      end.to change { Delayed::Job.count }.by(-1)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      triggered_task = create(:triggered_task, home: other_home)

      authenticate(home.user)
      delete :destroy, params: { id: triggered_task.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
