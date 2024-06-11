import {
  findUserById,
  findClubsById,
  findClubById,
  findEventsById,
  findUsersById,
  getAllClubs,
  getAllEvents,
  getAllUsers,
  findEventsByCategory,
  findEventsByKeywords,
  findUserByEmail,
  editUser,
  followClub,
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
    email:  String
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
  userInfo(email: String): user
  getUser(id: String): user
}

type Mutation{
  editUser(data: profileInput): user
  followClub(data: followInput): Boolean
}

input profileInput{
  _id: ID,
  name: String, 
  email: String,
  dp: String,
  keywords: [String]
}

input followInput{
  uid: ID,
  cid: ID
}
`;
const resolvers = {
  Query: {
    allEvents: async () => {
      let l = await getAllEvents();
      // console.log(l);
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
    clubInfo: async (_, args) => {
      return await findClubById(args.id);
    },
    userInfo: async (_, args) => {
      // console.log(args.email);
      return await findUserByEmail(args.email);
    },
    getUser: async (_, args) => {
      return await findUserById(args.id);
    },
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
  Mutation: {
    editUser: async (_, args) => {
      return await editUser(args.data);
    },
    followClub: async (_, args) => {
      return await followClub(args.data);
    }
  },
};
export { typeDefs, resolvers };
