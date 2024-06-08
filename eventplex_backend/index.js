import e from "express";
import mongoose from "mongoose";
import * as env from "dotenv";
import eventRounter from "./Controller/eventController.js";
import { ApolloServer } from "@apollo/server";
import { expressMiddleware } from "@apollo/server/express4";
import { resolvers, typeDefs } from "./Services/graphQLServices.js";
import cors from "cors";
import clubRouter from "./Controller/clubController.js";
import userRouter from "./Controller/userController.js";
// cors({
//   "allowedHeaders":"*",
//   "origin": "*",

// });
env.config();
const app = e();
app.use(cors());
// app.use((req, res, next) => {
//   // Set CORS headers to allow cross-origin requests (required to communicate with flutter thorugh localhosting)
//   res.setHeader("Access-Control-Allow-Origin", "*");
//   res.setHeader("Access-Control-Allow-Credentials", "True");
//   res.setHeader("Access-Control-Allow-Headers", "*");
//   res.setHeader(
//     "Access-Control-Allow-Methods",
//     "POST, OPTIONS, PUT, GET, DELETE"
//   );

//   next();
// });
app.use(e.json({ extended: true }));

try {
  mongoose.connect(process.env.MONGO_CONNECTION_URL).then(async () => {
    console.log("connected");
    app.get("/", (req, res) => {
      res.json({ msg: "Connected with Api" });
    });
    app.use("/Event", eventRounter);
    // Construct a schema, using GraphQL schema language

    const apolloServer = new ApolloServer({
      typeDefs: typeDefs,
      resolvers: resolvers,
    });
    await apolloServer.start();

    app.use("/graphql", expressMiddleware(apolloServer));
    app.use("/event", eventRounter);
    app.use("/club", clubRouter);
    app.use("/user", userRouter);

    const port = process.env.PORT || 3001;
    app.listen(port, () => console.log(`started on ${port}`));
  });
} catch (e) {
  console.log(e);
}
