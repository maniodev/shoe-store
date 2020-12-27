# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::DashboardController, type: :controller do
  before { allow(RefreshChart).to receive(:call) }

  shared_examples "calls refreshchart to refresh the chart" do
    it do
      expect(RefreshChart).to receive(:call).with(params: params)

      post :refresh, params: params
    end
  end

  describe "#index" do
    let!(:shoes) { create_list(:shoe, 2) }
    let!(:stores) { create_list(:store, 2) }
    let(:params) { {} }

    it "assigns variables for the select fields" do
      get :index

      expect(assigns(:shoe_models)).to eq(shoes.map(&:model))
      expect(assigns(:store_names)).to eq(stores.map(&:name))
    end

    it_behaves_like "calls refreshchart to refresh the chart"
  end

  describe "#chart" do
    let(:params) { { store: "ALDO Crossgates Mall", shoe_model: "GRELIDIEN" } }

    it_behaves_like "calls refreshchart to refresh the chart"
  end
end
