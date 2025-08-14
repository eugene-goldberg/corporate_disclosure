import axios from 'axios';
import { Category, QuestionRequest, QuestionResponse } from '../types';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8001';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const fetchCategories = async (): Promise<Category[]> => {
  try {
    const response = await api.get('/questions');
    const data = response.data;
    
    // Transform the API response to match our Category type
    const categories: Category[] = Object.entries(data.categories).map(([name, questions]) => ({
      name,
      questions: questions as any[],
      count: (questions as any[]).length,
    }));
    
    return categories;
  } catch (error) {
    console.error('Error fetching categories:', error);
    throw error;
  }
};

export const fetchQuestionsByCategory = async (category: string): Promise<Category> => {
  try {
    const response = await api.get(`/questions/${category}`);
    return response.data;
  } catch (error) {
    console.error('Error fetching questions by category:', error);
    throw error;
  }
};

export const generateAnswer = async (request: QuestionRequest): Promise<QuestionResponse> => {
  try {
    const response = await api.post('/answer', {
      ...request,
      year: request.year || 2024,
      include_sql: request.include_sql ?? true,
      include_reasoning: request.include_reasoning ?? true,
    });
    return response.data;
  } catch (error) {
    console.error('Error generating answer:', error);
    throw error;
  }
};