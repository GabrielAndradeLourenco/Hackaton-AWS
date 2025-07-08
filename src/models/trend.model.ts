export interface Trend {
  id: string;
  name: string;
}

export interface ImageGenerationRequest {
  productId: string;
  trendId: string;
}

export interface JobStatus {
  status: 'pending' | 'processing' | 'completed' | 'failed';
  imageUrl?: string;
}