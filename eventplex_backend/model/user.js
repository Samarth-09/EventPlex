import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  name: String,
  pastEvents: {
    type: [mongoose.Schema.Types.ObjectId],
    ref: "events",
  },
  currentEvents: {
    type: [mongoose.Schema.Types.ObjectId],
    ref: "events",
  },
  keywords: [String],
  dp: String,
  following: {
    type:[mongoose.Schema.Types.ObjectId],
    ref:'clubs'
  }
});

const UserModel = mongoose.model('users', userSchema);

export default UserModel;
