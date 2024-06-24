import EventModel from "../model/event.js";
import ClubModel from "../model/club.js";
import UserModel from "../model/user.js";
const getAllEvents = async () => {
  let result = [];
  try {
    result = await EventModel.find();
  } catch (error) {
    console.log("Error: " + e);
  }
  return result;
};

const getAllClubs = async () => {
  let result = [];
  try {
    result = await ClubModel.find();
  } catch (error) {
    console.log("Error: " + e);
  }
  return result;
};

const getAllUsers = async () => {
  let result = [];
  try {
    result = await UserModel.find();
  } catch (error) {
    console.log("Error: " + e);
  }
  return result;
};

const saveEvent = async (data) => {
  try {
    let d = new EventModel(data);
    await d.save();
    return d;
  } catch (error) {
    console.log(error);
  }
  return -1;
};

const findClubById = async (id) => {
  let result = {};
  try {
    result = await ClubModel.findById(id);
    // console.log(result+'2');
    return result;
  } catch (error) {
    console.log("error:- " + error);
  }
  return result;
};

const findEventsById = async (ids) => {
  let result = [];
  try {
    result = await EventModel.find({ _id: { $in: ids } });
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
};

const findUsersById = async (ids) => {
  let result = [];
  try {
    result = await UserModel.find({ _id: { $in: ids } });
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
};

const findClubsById = async (ids) => {
  let result = [];
  try {
    result = await ClubModel.find({ _id: { $in: ids } });
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
};

const findEventsByCategory = async (categorys) => {
  let result = [];
  try {
    result = await EventModel.find({ category: { $in: categorys } });
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
};

const findEventsByKeywords = async (keywords) => {
  let result = [];
  try {
    // console.log(1);
    result = await EventModel.find({ keywords: { $in: keywords } });
    // console.log(1);
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
};

const findEventById = async (id) => {
  var result;
  try {
    // console.log(id);
    result = await EventModel.findById(id);
    var x = await findClubById(result["club"].toString());
    // result['club'] = {'club': x['name']}; the value of the result was not changint=g, so ahve to create new object only
    var r = {
      ...result,
      Club: {
        name: x["name"],
      },
    };
    // console.log(r['Club']);
  } catch (error) {
    console.log("Error:- " + error);
  }
  return r;
};

const findUserByEmail = async (email) => {
  let result = [];
  try {
    // console.log(1);
    result = await UserModel.find({ email: email });
    // console.log(result[0].email);
  } catch (error) {
    console.log("Error " + error);
  }
  return result[0];
};
const findUserById = async (id) => {
  let result = 0;
  try {
    // console.log(1);
    result = await UserModel.findById(id);
    // console.log(result);
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
};

const saveUser = async (data) => {
  try {
    const user = new UserModel(data);
    await user.save();
    return user;
  } catch (error) {
    console.log(error);
    return 0;
  }
};

const editUser = async (data) => {
  try {
    // console.log(data);
    let result = await findUserById(data._id);
    result.dp = data.dp == null ? result.dp : data.dp;
    result.name = data.name == null ? result.name : data.name;
    result.email = data.email == null ? result.email : data.email;
    result.keywords = data.keywords == null ? result.keywords : data.keywords;
    await result.save();
    return result;
  } catch (error) {
    console.log(error);
    return 0;
  }
};

const followClub = async (data) => {
  try {
    let user = await findUserById(data.uid);
    let club = await findClubById(data.cid);
    user.following.push(club._id);
    club.followers.push(user._id);
    // console.log(user.followers);
    await user.save();
    await club.save();
    return user;
  } catch (error) {
    console.log(error);
    return 0;
  }
};
const unFollowClub = async (data) => {
  try {
    let user = await findUserById(data.uid);
    let club = await findClubById(data.cid);
    user.following.remove(club._id);
    club.followers.remove(user._id);
    await user.save();
    await club.save();
    return user;
  } catch (error) {
    console.log(error);
    return 0;
  }
};
const changeLike = async (data) => {
  try {
    let event = await EventModel.findById(data.eid);
    console.log(event);
    event.likes += data.type == "+" ? 1 : -1;
    await event.save();
    return event;
  } catch (error) {
    console.log(error);
    return 0;
  }
};
const changeDisLike = async (data) => {
  try {
    let event = await EventModel.findById(data.eid);
    event.dislikes += data.type == "+" ? 1 : -1;
    await event.save();
    return event;
  } catch (error) {
    console.log(error);
    return 0;
  }
};
const saveClub = async (data) => {
  try {
    let club = new ClubModel(data);
    await club.save();
    return club;
  } catch (error) {
    console.log(error);
    return 0;
  }
};
const findClubByEmail = async (email) => {
  let result = [];
  try {
    // console.log(1);
    result = await ClubModel.find({ email: email });
    // console.log(result[0].email);
  } catch (error) {
    console.log("Error " + error);
  }
  return result[0];
};
export {
  findClubByEmail,
  saveClub,
  changeDisLike,
  changeLike,
  unFollowClub,
  followClub,
  editUser,
  saveUser,
  findUserById,
  findUserByEmail,
  findEventById,
  findEventsByKeywords,
  findEventsByCategory,
  findClubsById,
  findUsersById,
  getAllEvents,
  saveEvent,
  getAllClubs,
  getAllUsers,
  findClubById,
  findEventsById,
};
