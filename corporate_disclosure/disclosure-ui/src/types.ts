export interface Question {
  question: string;
}

export interface Category {
  name: string;
  questions: Question[];
  count: number;
}

export interface QuestionResponse {
  question: string;
  answer: string;
  sql_queries?: SQLQuery[];
  reasoning?: string;
  processing_time: number;
  timestamp: string;
}

export interface SQLQuery {
  name: string;
  sql: string;
  purpose: string;
}

export interface QuestionRequest {
  question: string;
  year?: number;
  include_sql?: boolean;
  include_reasoning?: boolean;
}