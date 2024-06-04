import e from "express";
import { saveEvent, findEventById } from "../Services/mongoServices.js";

const eventRounter = e.Router();

eventRounter.post("/saveEvent", (req, res) => {
    // console.log(req.body.images);
  const result = saveEvent(req.body);
  res.json({ msg: result });
});

eventRounter.get("/byid", async (req, res) => {
  var id = req.query.id;
  console.log(id);
  const result = await findEventById(id);
  if (result == 0) {
    res.json({ msg: "Not Found" });
  } else {
    // console.log(result);
    res.json(result);
  }
});

export default eventRounter;
