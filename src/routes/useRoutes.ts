import { Router } from "express";
import { userController } from "../controllers/useController";
const router = Router();

router.get("/", userController.list);