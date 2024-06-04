import {
  findClubsById,
  findClubById,
  findEventsById,
  findUsersById,
  getAllClubs,
  getAllEvents,
  getAllUsers,
  findEventsByCategory,
  findEventsByKeywords,
} from "./mongoServices.js";
const typeDefs = `#graphql
type club {
    _id:ID
    name: String
    pastEvents: [event]
    currentEvents: [event]
    followers: [user]
    dp: String
}
type user {
    _id:ID
    name: String
    currentEvents: [event]
    pastEvents: [event]
    keywords: [String]
    following: [club]
    dp: String
}
type event {
  _id:ID
  name: String
  location: String
  date: String
  time: String
  fees: Int
  category: String
  totalTickets: Int
  ticketsRemaining: Int
  likes: Int
  dislikes: Int
  comments: [String]
  keywords: [String]
  images: [String]
  rating: Float
  Club: club
}
type Query{
    allEvents: [event]
    allClubs: [club]
    allUsers: [user]
    allEventsAccToCategory(category: [String]): [event]
    allEventsAccToKeywords(keywords: [String]): [event]
    clubInfo(id: String): club
}

`;
const resolvers = {
  Query: {
    allEvents: async () => {
      let l = await getAllEvents();
      console.log(l);
      return l;
    },
    allClubs: async () => {
      return await getAllClubs();
    },
    allUsers: async () => {
      return await getAllUsers();
    },
    allEventsAccToCategory: async (_, args) => {
      return await findEventsByCategory(args.category);
    },
    allEventsAccToKeywords: async (_, args) => {
      return await findEventsByKeywords(args.keywords);
    },
    clubInfo: async(_, args) => {
      return await findClubById(args.id);
    }
  },
  event: {
    Club: async (parent) => {
      return await findClubById(parent.club);
    },
  },
  club: {
    pastEvents: async (parent) => {
      return await findEventsById(parent.pastEvents);
    },
    currentEvents: async (parent) => {
      return await findEventsById(parent.currentEvents);
    },
    followers: async (parent) => {
      return await findUsersById(parent.followers);
    },
  },
  user: {
    pastEvents: async (parent) => {
      return await findEventsById(parent.pastEvents);
    },
    currentEvents: async (parent) => {
      return await findEventsById(parent.currentEvents);
    },
    following: async (parent) => {
      return await findClubsById(parent.following);
    },
  },
};
export { typeDefs, resolvers };
