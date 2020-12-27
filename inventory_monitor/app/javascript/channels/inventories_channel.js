import consumer from "./consumer"
consumer.subscriptions.create("InventoriesChannel", {
  connected() {},
  disconnected() {},
  received(data) {
  }
});
