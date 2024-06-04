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
    return d.save();
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
    result = await EventModel.find({ category: { $in:  categorys} });
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
};

const findEventsByKeywords = async (keywords) => {
  let result = [];
  try {
    // console.log(1);
    result = await EventModel.find({ keywords: { $in:  keywords} });
    // console.log(1);
  } catch (error) {
    console.log("Error " + error);
  }
  return result;
}

const findEventById = async (id) => {
  var result;
  try {
    // console.log(id);
    result = await EventModel.findById(id);
    var x = await findClubById(result['club'].toString());
    // result['club'] = {'club': x['name']}; the value of the result was not changint=g, so ahve to create new object only
    var r = {
      ...result,
      'Club': {
        'name': x['name']
      }
    }
    // console.log(r['Club']);
  } catch (error) {
    console.log("Error:- "+error);
  }
  return r;
}

export {
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
