const mongoose = require("mongoose");
// this data dealing is cited by chatgot
// define product schema
const ItemSchema = new mongoose.Schema({
  createdAt: {
    type: Date,
    default: Date.now,
  },
  galleryURL: [String],
  itemId: { type: [String], unique: true },
  title: [String],
  postalCode: [String],
  shippingInfo: [
    {
      shippingServiceCost: [
        {
          "@currencyId": String,
          __value__: String,
        },
      ],
      shippingType: [String],
      shipToLocations: [String],
      expeditedShipping: [String],
      oneDayShippingAvailable: [String],
      handlingTime: [Number],
    },
  ],
  sellingStatus: [
    {
      currentPrice: [
        {
          "@currencyId": String,
          __value__: String,
        },
      ],
      convertedCurrentPrice: [
        {
          "@currencyId": String,
          __value__: String,
        },
      ],
      sellingState: [String],
      timeLeft: [String],
    },
  ],
  returnsAccepted: [String],

  // condition used
  condition: [
    {
      conditionId: [String],
      conditionDisplayName: [String],
    },
  ],
});

// export schema
const Item = mongoose.model("Item", ItemSchema);
module.exports = Item;
