import e from "express";
import { saveEvent, findEventById, updateEvent } from "../Services/mongoServices.js";

const eventRounter = e.Router();

eventRounter.post("/new", async (req, res) => {
    // console.log(req.body.images);
  const result = await saveEvent(req.body);
  // console.log(result);
  if(result == 0){
    res.json({msg: "Error in saving"});
  }
  else{
    res.json(result);
  }
});

eventRounter.get("/byid", async (req, res) => {
  var id = req.query.id;
  // console.log(id);
  const result = await findEventById(id);
  if (result == 0) {
    res.json({ msg: "Not Found" });
  } else {
    // console.log(result);
    res.json(result);
  }
});

eventRounter.post("/update", async (req, res) => {
  const result = await updateEvent(req.body);
  if (result == 0) {
    res.json({ msg: "Error in updating" });
  } else {
    res.json(result);
  }
});

export default eventRounter;
