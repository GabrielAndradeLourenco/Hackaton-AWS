import { Request, Response } from 'express';
import { Product, CreateProductRequest } from '../../models/product.model';

export const addProduct = (req: Request, res: Response) => {
  const productData: CreateProductRequest = req.body;
  console.log('Product data received:', productData);
  
  res.status(201).json({ message: 'Product added successfully', data: productData });
};

export const getProducts = (req: Request, res: Response) => {
  const products: Product[] = [
    {
      id: '1',
      name: 'Smartphone XYZ',
      price: 899.99,
      imageUrl: 'https://example.com/smartphone.jpg'
    },
    {
      id: '2',
      name: 'Laptop ABC',
      price: 1299.99,
      imageUrl: 'https://example.com/laptop.jpg'
    }
  ];
  
  res.json(products);
};