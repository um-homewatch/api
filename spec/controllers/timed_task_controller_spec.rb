require "rails_helper"

describe Tasks::TimedTaskController, type: :controller do
  let(:home) { create(:home) }

  def timed_task_params_thing(thing)
    attributes_for(
      :timed_task,
      thing_id: thing.id,
      cron: "10 * * * *",
    )
  end

  def timed_task_params_scenario(scenario)
    attributes_for(
      :timed_task,
      scenario_id: scenario.id,
      cron: "10 * * * *",
    )
  end

  describe "GET #index" do
    it "returns the timed tasks of a home" do
      timed_tasks = create_list(:timed_task, 3, home: home)
      json = serialize_to_json(timed_tasks)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      create_list(:timed_task, 3, home: other_home)

      authenticate(home.user)
      get :index, params: { home_id: other_home.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a timed_task" do
      timed_task = create(:timed_task, home: home)
      json = serialize_to_json(timed_task)

      authenticate(home.user)
      get :show, params: { id: timed_task.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      timed_task = create(:timed_task, home: other_home)

      authenticate(home.user)
      get :show, params: { id: timed_task.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create with thing" do
    it "creates a timed_task" do
      thing = create(:light, home: home)
      timed_task_params = timed_task_params_thing(thing)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, timed_task: timed_task_params }
      end.to change { Tasks::TimedTask.count }.by(1)
    end

    it "returns the created resource" do
      thing = create(:light, home: home)
      timed_task_params = timed_task_params_thing(thing)

      authenticate(home.user)
      post :create, params: { home_id: home.id, timed_task: timed_task_params }

      expect(parsed_response[:cron]).to eq(timed_task_params[:cron])
      expect(parsed_response[:thing][:id]).to eq(timed_task_params[:thing_id])
      expect(parsed_response[:status]).to eq(timed_task_params[:status])
      expect(parsed_response[:next_run]).to be_truthy
    end

    it "returns a not found status code" do
      other_home = create(:home)
      timed_task_params = attributes_for(:timed_task)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, timed_task: timed_task_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create with scenario" do
    it "creates a timed_task" do
      scenario = create(:scenario, home: home)
      timed_task_params = timed_task_params_scenario(scenario)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, timed_task: timed_task_params }
      end.to change { Tasks::TimedTask.count }.by(1)
    end

    it "returns the created resource" do
      scenario = create(:scenario, home: home)
      timed_task_params = timed_task_params_scenario(scenario)

      authenticate(home.user)
      post :create, params: { home_id: home.id, timed_task: timed_task_params }

      expect(parsed_response[:cron]).to eq(timed_task_params[:cron])
      expect(parsed_response[:scenario][:id]).to eq(timed_task_params[:scenario_id])
      expect(parsed_response[:next_run]).to be_truthy
    end
  end

  describe "PUT #update" do
    it "updates the info of a timed_task" do
      timed_task = create(:timed_task, home: home)
      thing = create(:light, home: home)
      timed_task_params = timed_task_params_thing(thing)

      authenticate(home.user)
      put :update, params: { id: timed_task.id, timed_task: timed_task_params }
      timed_task.reload

      expect(timed_task.cron).to eq(timed_task_params[:cron])
      expect(timed_task.thing.id).to eq(timed_task_params[:thing_id])
      expect(timed_task.status_to_apply.symbolize_keys).to eq(timed_task_params[:status_to_apply])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      timed_task = create(:timed_task, home: other_home)
      timed_task_params = attributes_for(:timed_task)

      authenticate(home.user)
      put :update, params: { id: timed_task.id, timed_task: timed_task_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested timed_task" do
      timed_task = create(:timed_task, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { id: timed_task.id }
      end.to change { Tasks::TimedTask.count }.by(-1)
    end

    it "destroys the associated delayed job" do
      timed_task = create(:timed_task, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { id: timed_task.id }
      end.to change { Delayed::Job.count }.by(-1)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      timed_task = create(:timed_task, home: other_home)

      authenticate(home.user)
      delete :destroy, params: { id: timed_task.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
