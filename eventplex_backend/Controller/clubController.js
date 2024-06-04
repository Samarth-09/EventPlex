import e from "express";
import { findClubById } from "../Services/mongoServices.js";

const clubRouter = e.Router();

clubRouter.get("/byid", async (req, res) => {
    var id = req.query.id;
  const result = await findClubById(id);
  if (result == 0) {
    res.json({ msg: "Not Found" });
  } else {
    // console.log(result);
    res.json(result);
  }
});

export default clubRouter;