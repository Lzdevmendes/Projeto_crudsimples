import { userController } from "./controllers/useController";

const express = require('express');

const bodyParser = require('body-parser');

const app = express();

import { Request, Response } from "express";

app.get('/', (req: Request, res: Response) => {
  res.send('Hello World teste');
});

app.use(bodyParser.json());
app.use("/user", userController.list);

app.listen(3000, () => {
  console.log('Server is running on port 3000');

});
