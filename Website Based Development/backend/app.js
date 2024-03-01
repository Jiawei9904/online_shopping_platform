const express = require("express");
const axios = require("axios");
const cors = require("cors");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 3000;

const mongoose = require("mongoose");
const router = express.Router();

app.use(cors({ origin: "*" }));
app.options("*", cors());
// Enable CORS for all routes
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.get("/search", async (req, res) => {
  const keywords = req.query.keywords;
  const conditions = req.query.conditions
    ? JSON.parse(req.query.conditions)
    : [];
  const shippingOptions = req.query.shippingOptions;
  const localPickup = req.query.localPickup;
  const postalCode = req.query.postalCode;
  const maxDistance = req.query.maxDistance;
  const category = req.query.category; // Extract category from query
  const filters = [];

  if (conditions.length) {
    filters.push({ name: "Condition", value: conditions });
  }

  if (shippingOptions === "free") {
    filters.push({ name: "FreeShippingOnly", value: "true" });
  }

  if (localPickup === "localPickup") {
    filters.push({ name: "LocalPickupOnly", value: "true" });
  }

  const params = {
    "OPERATION-NAME": "findItemsAdvanced",
    "SERVICE-VERSION": "1.0.0",
    "SECURITY-APPNAME": "JiaweiGu-Jiawei57-PRD-4dd800d9a-8dd1f31c",
    "RESPONSE-DATA-FORMAT": "JSON",
    keywords: keywords,
    "paginationInput.entriesPerPage": "50",
  };

  if (postalCode) {
    params["buyerPostalCode"] = postalCode;
  }

  if (maxDistance) {
    params["MaxDistance"] = maxDistance;
  }

  if (category && category !== "default") {
    // Ensure category is present and not 'default'
    params["categoryId"] = category;
  }

  filters.forEach((filter, i) => {
    params[`itemFilter(${i}).name`] = filter.name;
    if (Array.isArray(filter.value)) {
      filter.value.forEach((v, j) => {
        params[`itemFilter(${i}).value(${j})`] = v;
      });
    } else {
      params[`itemFilter(${i}).value`] = filter.value;
    }
  });

  console.log(params);

  try {
    const response = await axios.get(
      "https://svcs.ebay.com/services/search/FindingService/v1",
      { params: params }
    );
    console.log(params);
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch data from eBay." });
  }
});

// eBay get item endpoint
const OAuthToken = require("./ebay_oauth_token");
const client_id = "JiaweiGu-Jiawei57-PRD-4dd800d9a-8dd1f31c";
const client_secret = "PRD-dd800d9a6857-68c7-4d0d-906f-4664";
const oauthToken = new OAuthToken(client_id, client_secret);
oauthToken
  .getApplicationToken()
  .then((accessToken) => {
    console.log("Access Token:", accessToken);
  })
  .catch((error) => {
    console.log("Error", error);
  });
app.get("/getItemDetails/:itemId", async (req, res) => {
  // const item_id = req.query.item_id;
  const item_id = req.params.itemId;
  console.log(item_id);
  if (!item_id) {
    return res.status(400).json({ error: "Item ID is required" });
  }

  const params = {
    callname: "GetSingleItem",
    responseencoding: "JSON",
    appid: "JiaweiGu-Jiawei57-PRD-4dd800d9a-8dd1f31c",
    siteid: "0",
    version: "967",
    ItemID: item_id,
    IncludeSelector: "Description,Details,ItemSpecifics",
  };
  console.log(params);
  const headers = {
    "X-EBAY-API-IAF-TOKEN": await oauthToken.getApplicationToken(),
  };

  try {
    const response = await axios.get("https://open.api.ebay.com/shopping", {
      params: params,
      headers: headers,
    });
    res.json(response.data);
    console.log(response);
    console.log("get data!");
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch data from eBay." });
  }
});

// Serve static files
app.get("/", (req, res) => {
  res.send("Server is Running.");
});

app.listen(PORT, () => {
  console.log(`Server started on http://localhost:${PORT}`);
});

// mongo db
const mongoDBUrl =
  "mongodb+srv://jiaweiguo429:Richard429@cluster0.q4zdsf5.mongodb.net/?retryWrites=true&w=majority";
mongoose.connect(mongoDBUrl, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

mongoose.connection.on("error", (err) => {
  console.error("Failed to connect to MongoDB", err);
});

mongoose.connection.once("open", () => {
  console.log("Connected to MongoDB");
});

// add, remove
const Item = require("./models/item.model"); // 更新这个路径以指向您的模型文件
// add
app.post("/api/addToCart", async (req, res) => {
  // 从请求体中获取商品数据
  const itemData = req.body;
  console.log(itemData);
  // 检查 itemId 是否是数组，并获取第一个元素
  if (Array.isArray(itemData.itemId)) {
    itemData.itemId = itemData.itemId[0];
  }

  try {
    // 使用接收到的数据创建 Item 模型的一个新实例
    const newItem = new Item(itemData);

    // 将新商品项保存到数据库
    await newItem.save();

    // 发送一个成功响应
    res.status(201).json({ message: "Item added successfully!" });
  } catch (error) {
    // 如果出现错误，发送一个错误响应
    res.status(500).json({ message: error.message });
  }
});

// remove
app.post("/api/removeFromCart", async (req, res) => {
  const { itemId } = req.body; // 从请求体中获取 itemId

  try {
    // 在数据库中找到该项目并删除它
    await Item.findOneAndDelete({ itemId: itemId });

    res.json({ message: "Item removed from cart successfully" });
  } catch (error) {
    console.error("Error removing item from cart: ", error);
    res.status(500).json({ message: error.message });
  }
});

//get
app.get("/api/wishlist", async (req, res) => {
  try {
    // const wishlistItems = await Item.find();
    const wishlistItems = await Item.find().sort({ createdAt: 1 }); // 假设您有一个 Wishlist 模型
    res.json(wishlistItems);
    console.log(wishlistItems);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// get all ItemId
app.get("/api/getItemIds", async (req, res) => {
  try {
    // 查询所有商品，但只返回 'itemId' 字段
    const itemIds = await Item.find({}, "itemId -_id"); // '-_id' 是说我们不想返回默认的 MongoDB '_id' 字段
    // 这将是一个对象数组，例如：[{itemId: 'id1'}, {itemId: 'id2'}, ...]
    // 如果你想要一个纯粹的 'itemId' 字符串数组，你可以简单地从这些对象中提取它们
    const idArray = itemIds.map((item) => item.itemId);

    res.json(idArray); // 返回 itemId 数组
    console.log(idArray);
  } catch (error) {
    console.error("Error fetching item IDs: ", error);
    res.status(500).send("Internal Server Error");
  }
});

// get similar product
app.get("/getSimilarItems/:itemId", async (req, res) => {
  const itemId = req.params.itemId; // 从 URL 中获取 itemId

  // 检查 itemId 是否提供
  if (!itemId) {
    return res.status(400).json({ error: "Item ID is required" });
  }

  try {
    // 准备调用 eBay API 的参数
    const params = new URLSearchParams({
      "OPERATION-NAME": "getSimilarItems",
      "SERVICE-NAME": "MerchandisingService",
      "SERVICE-VERSION": "1.1.0",
      "CONSUMER-ID": "JiaweiGu-Jiawei57-PRD-4dd800d9a-8dd1f31c", // 用你的 eBay App ID 替换
      "RESPONSE-DATA-FORMAT": "JSON",
      "REST-PAYLOAD": "",
      itemId: itemId,
      maxResults: "20", // 或任何你想要的结果数量
    });

    // 发起对 eBay API 的请求
    const response = await axios.get(
      `https://svcs.ebay.com/MerchandisingService?${params.toString()}`
    );

    // 发回结果
    res.json(response.data);
  } catch (error) {
    console.error("Error fetching similar items: ", error.message);
    res.status(500).json({
      error: "Failed to fetch similar items.",
      details: error.message,
    });
  }
});

// for photo getting function
const apiKey = "AIzaSyByo8fe0VKf3ZRdybnbZACtTVVMaxe9xS8"; //  Google Custom Search API key
const searchEngineId = "b761d3d029c2246c1"; // search engine ID

app.get("/searchImages/:productTitle", async (req, res) => {
  const productTitle = req.params.productTitle; // 从 URL 中获取产品标题

  if (!productTitle) {
    return res.status(400).json({ error: "Product title is required" });
  }

  try {
    const url = "https://www.googleapis.com/customsearch/v1";

    const params = {
      q: productTitle, // 设置 'q' 为你从 URL 参数中获取的产品标题
      cx: searchEngineId,
      imgSize: "huge",
      imgType: "photo",
      num: 8,
      searchType: "image",
      key: apiKey,
    };

    // 发起带有参数的 GET 请求
    const response = await axios.get(url, { params });

    // 返回结果
    res.json(response.data);
  } catch (error) {
    console.error("Error performing the search:", error.message);
    res.status(500).json({
      error: "Failed to perform the search.",
      details: error.message,
    });
  }
});

// facebook post
app.post("/api/generateFacebookShareLink", (req, res) => {
  const { productName, price, link } = req.body;

  if (!productName || !price || !link) {
    return res
      .status(400)
      .json({ error: "Some essential item properties are missing" });
  }

  const shareContent = `Buy ${productName} at ${price} from ${link} below.`;
  const encodedShareContent = encodeURIComponent(shareContent);
  const shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(
    link
  )}&quote=${encodedShareContent}`;

  res.json({ shareUrl });
});

// postal code
app.get("/api/postalCodeSearch", async (req, res) => {
  try {
    const response = await axios.get(
      `http://api.geonames.org/postalCodeSearchJSON`,
      {
        params: {
          postalcode_startsWith: req.query.postalcode_startsWith,
          maxRows: req.query.maxRows,
          username: "jiawei_9904",
          country: "US",
        },
      }
    );
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
