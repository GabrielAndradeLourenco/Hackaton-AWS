export interface Product {
  id: string;
  name: string;
  price: number;
  imageUrl: string;
}

export interface CreateProductRequest {
  name: string;
  price: number;
  imageUrl: string;
}