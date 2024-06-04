import mongoose from 'mongoose';

const eventSchema = new mongoose.Schema({
  name: String,
  location: String,
  date: String,
  time: String,
  fees: Number,
  category: String,
  totalTickets: Number,
  ticketsRemaining: Number,
  likes: { type: Number, default: 0 },
  dislikes: { type: Number, default: 0 },
  comments: [String],
  keywords: [String],
  club: { type: mongoose.Schema.Types.ObjectId, ref: 'clubs' },
  images: [String],
  rating: Number,
  desciption: String
});

const EventModel = mongoose.model('events', eventSchema);

export default EventModel;
