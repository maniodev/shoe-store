# frozen_string_literal: true

require "rails_helper"

RSpec.describe Store, type: :model do
  subject(:model) { create(:store) }

  describe "associations" do
    it { is_expected.to have_many(:shoes).through(:inventories) }
    it { is_expected.to have_many(:inventories).dependent(:destroy) }
  end
end
