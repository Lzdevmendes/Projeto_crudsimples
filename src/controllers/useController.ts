import { Request, Response } from "express";
import { useService } from "../services/useService";


export const userController = {
  list(req: Request, res: Response) {
    useService.list();
    res.status(200).json({
      message: "User list retrieved successfully",
      data: {
        id: 1,
        name: "Hello World"
      }
    });
  },
    }
