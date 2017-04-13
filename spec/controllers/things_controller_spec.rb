require "rails_helper"

describe ThingsController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #index" do
    it "returns the things of a home" do
      things = create_list(:thing, 3, home: home)
      json = serialize_to_json(things)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end
  end

  describe "GET #show" do
    it "returns a thing from a home" do
      thing = create(:thing, home: home)
      json = serialize_to_json(thing)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: thing.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      thing = create(:thing)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: thing.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user thing" do
      thing_params = attributes_for(:thing, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: thing_params }
      end.to change { home.things.count }.by(1)
    end

    it "returns the created resource" do
      thing_params = attributes_for(:thing)

      authenticate(home.user)
      post :create, params: { home_id: home.id, thing: thing_params }

      expect(parsed_response[:kind]).to eq(thing_params[:kind])
      expect(parsed_response[:subtype]).to eq(thing_params[:subtype])
      expect(parsed_response[:payload]).to eq(thing_params[:payload])
    end
  end

  describe "PUT #update" do
    it "updates a user thing" do
      thing = create(:thing, home: home)
      thing_params = attributes_for(:thing)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: thing.id, thing: thing_params }
      thing.reload

      expect(thing.kind).to eq(thing_params[:kind])
      expect(thing.subtype).to eq(thing_params[:subtype])
      expect(thing.payload).to eq(thing_params[:payload])
    end

    it "returns a not found status code" do
      thing = create(:thing)
      thing_params = attributes_for(:thing)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: thing.id, thing: thing_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested thing" do
      thing = create(:thing, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { home_id: home.id, id: thing.id }
      end.to change { home.things.count }.by(-1)
    end

    it "returns a not found status code" do
      thing = create(:thing)

      authenticate(home.user)
      delete :destroy, params: { home_id: home.id, id: thing.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
