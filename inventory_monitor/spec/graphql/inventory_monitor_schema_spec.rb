# frozen_string_literal: true

require "rails_helper"

RSpec.describe InventoryMonitorSchema do
  1.upto(2) do |n|
    let!(:"shoe#{n}") { create(:shoe) }
    let!(:"store#{n}") { create(:store) }
  end
  let!(:inventory) { create(:inventory, store: store1, shoe: shoe1) }
  let(:variables) { {} }

  shared_examples "loads data" do
    it do
      result = described_class.execute(query, variables: variables)
      expect(result["data"]).to eq expected_result.deep_stringify_keys
    end
  end

  describe "stores" do
    let(:query) do
      '
        query {
          stores {
            id
            name
            shoes {
              model
            }
          }
        }
      '
    end

    let(:expected_result) do
      {
        stores: [
          { id: store1.id.to_s, name: store1.name, shoes: [{ model: store1.shoes.first.model }] },
          { id: store2.id.to_s, name: store2.name, shoes: [] }
        ]
      }
    end

    it_behaves_like "loads data"

    context "when id is passed" do
      let(:query) do
        '
          query($id: ID!) {
            store(id: $id) {
              id
              name
              shoes {
                model
              }
            }
          }
        '
      end
      let(:expected_result) do
        {
          store: { id: store1.id.to_s, name: store1.name, shoes: [{ model: store1.shoes.first.model }] }
        }
      end
      let(:variables) { { id: store1.id } }

      it_behaves_like "loads data"
    end
  end

  describe "shoes" do
    let(:query) do
      '
        query {
          shoes {
            id
            model
            stores {
              name
            }
          }
        }
      '
    end

    let(:expected_result) do
      {
        shoes: [
          { id: shoe1.id.to_s, model: shoe1.model, stores: [{ name: store1.name }] },
          { id: shoe2.id.to_s, model: shoe2.model, stores: [] }
        ]
      }
    end

    it_behaves_like "loads data"

    context "when id is passed" do
      let(:variables) { { id: shoe1.id } }
      let(:query) do
        '
          query($id: ID!) {
            shoe(id: $id) {
              id
              model
              stores {
                name
              }
            }
          }
        '
      end
      let(:expected_result) do
        {
          shoe: { id: shoe1.id.to_s, model: shoe1.model, stores: [{ name: store1.name }] }
        }
      end

      it_behaves_like "loads data"
    end
  end

  describe "inventories" do
    let(:query) do
      '
        query {
          inventories {
            shoe {
              model
            }
            store {
              name
            }
          }
        }
      '
    end

    let(:expected_result) do
      {
        inventories: [{ shoe: { model: shoe1.model }, store: { name: store1.name } }]
      }
    end

    it_behaves_like "loads data"
  end
end
