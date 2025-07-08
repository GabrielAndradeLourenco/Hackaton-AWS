import { Request, Response } from 'express';
import { Trend } from '../../models/trend.model';

export const getAvailableTrends = (req: Request, res: Response) => {
  const trends: Trend[] = [
    { id: 'dia-das-maes', name: 'Dia das Mães' },
    { id: 'black-friday', name: 'Black Friday' },
    { id: 'natal', name: 'Natal' },
    { id: 'verao', name: 'Verão' }
  ];
  
  res.json(trends);
};