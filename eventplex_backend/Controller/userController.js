import e from "express";
import { findUserById, saveUser } from "../Services/mongoServices.js";

const userRouter = e.Router();
userRouter.get("/byid", async (req, res) => {
  const result = await findUserById(req.query.id);
  if (result == 0) {
    res.json({ msg: "Error" });
  } else {
    res.json(result);
  }
});

userRouter.post("/new", async (req, res) => {
  const result = await saveUser(req.body);
  if (result == 0) {
    res.json({ msg: "Error in saving" });
  } else {
    // console.log(result);
    res.json(result);
  }
});
export default userRouter;
