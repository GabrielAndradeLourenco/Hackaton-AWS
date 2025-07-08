import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

import trendRoutes from './api/routes/trends.routes';
import productRoutes from './api/routes/products.routes';
import imageRoutes from './api/routes/image.routes';

dotenv.config();

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.use('/api/v1/trends', trendRoutes);
app.use('/api/v1/products', productRoutes);
app.use('/api/v1/images', imageRoutes);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

export default app;