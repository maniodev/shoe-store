# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::DashboardController, type: :controller do
  describe "#index" do
    let!(:shoes) { create_list(:shoe, 2) }
    let!(:stores) { create_list(:store, 2) }
    let(:params) { {} }

    it "assigns variables for the select fields" do
      get :index

      expect(assigns(:shoe_models)).to eq(shoes.map(&:model))
      expect(assigns(:store_names)).to eq(stores.map(&:name))
    end

  end
end
