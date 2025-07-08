import { Router } from 'express';
import { getAvailableTrends } from '../controllers/trends.controller';

const router = Router();

router.get('/', getAvailableTrends);

export default router;