import e from "express";
import { findUserById } from "../Services/mongoServices.js";
const userRouter = e.Router();

userRouter.get("/byid", async (req, res) => {
  const result = await findUserById(req.query.id);
  if (result == 0) {
    res.json({msg: "Error"});
  }
  else{
    res.json(result);
  }
});

export default userRouter;