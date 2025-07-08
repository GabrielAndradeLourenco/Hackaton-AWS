import { Router } from 'express';
import { createImageRequest, getJobStatus } from '../controllers/image.controller';

const router = Router();

router.post('/generate', createImageRequest);
router.get('/status/:jobId', getJobStatus);

export default router;