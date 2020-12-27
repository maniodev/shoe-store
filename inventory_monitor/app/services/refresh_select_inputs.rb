# frozen_string_literal: true

class RefreshSelectInputs
  include Interactor

  def call
    shoe_models = Shoe.all.map(&:model)
    store_names = Store.all.map(&:name)

    ActionCable.server.broadcast "dashboard_channel", {
      type: "select_inputs",
      data: { shoe_models: shoe_models, store_names: store_names }
    }
  end
end
