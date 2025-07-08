import { Request, Response } from 'express';
import { ImageGenerationRequest, JobStatus } from '../../models/trend.model';
import { ImageGenerationService } from '../services/image-generation.service';

const imageService = new ImageGenerationService();

export const createImageRequest = async (req: Request, res: Response) => {
  try {
    const { productId, trendId }: ImageGenerationRequest = req.body;
    
    if (!productId || !trendId) {
      return res.status(400).json({ error: 'productId and trendId are required' });
    }
    
    const jobId = await imageService.startGeneration(productId, trendId);
    
    res.status(202).json({ jobId });
  } catch (error) {
    res.status(500).json({ error: 'Failed to start image generation' });
  }
};

export const getJobStatus = (req: Request, res: Response) => {
  const { jobId } = req.params;
  
  // Mock status response
  const status: JobStatus = {
    status: 'completed',
    imageUrl: 'http://example.com/final-image.jpg'
  };
  
  res.json(status);
};