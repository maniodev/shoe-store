# frozen_string_literal: true

require "rails_helper"

RSpec.describe Shoe, type: :model do
  subject(:model) { create(:shoe) }

  describe "associations" do
    it { is_expected.to have_many(:stores).through(:inventories) }
    it { is_expected.to have_many(:inventories).dependent(:destroy) }
  end
end
