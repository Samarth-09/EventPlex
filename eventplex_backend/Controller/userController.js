import e from "express";
import multer from "multer";
import { findUserById, saveUser } from "../Services/mongoServices.js";

const userRouter = e.Router();
const upload = multer({
  storage: multer.diskStorage({
    destination: function (req, file, cb){
      cb(null, 'uploads');
    },
    filename:function(req, file, cb){
      cb(null, file.filename+"-"+Date.now()+".jpg");
    }
  })
}).single('userFile');
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

userRouter.post("/imageUpload",upload,async (req, res) => {
  console.log(1);
  res.json({msg:"done"});
});
export default userRouter;
