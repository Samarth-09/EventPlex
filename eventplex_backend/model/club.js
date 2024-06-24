import mongoose from "mongoose";

const clubSchema = new mongoose.Schema({
  name: String,
  pastEvents: {
    type: [mongoose.Schema.Types.ObjectId],
    ref: "events",
  },
  currentEvents: {
    type: [mongoose.Schema.Types.ObjectId],
    ref: "events",
  },
  followers: {
    type: [mongoose.Schema.Types.ObjectId],
    ref: "users",
  },
  dp: String,
  email: String
});

const ClubModel = mongoose.model("clubs", clubSchema);

export default ClubModel;
