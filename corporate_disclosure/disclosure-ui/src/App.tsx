import React, { useState, useEffect } from 'react';
import './App.css';
import Sidebar from './components/Sidebar';
import MainPanel from './components/MainPanel';
import { Category, Question } from './types';
import { fetchCategories } from './services/api';

function App() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [selectedQuestion, setSelectedQuestion] = useState<Question | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadCategories();
  }, []);

  const loadCategories = async () => {
    try {
      setLoading(true);
      const data = await fetchCategories();
      setCategories(data);
    } catch (error) {
      console.error('Error loading categories:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleQuestionSelect = (question: Question) => {
    setSelectedQuestion(question);
  };

  return (
    <div className="App">
      <header className="app-header">
        <div className="header-content">
          <h1>Corporate Disclosure Management</h1>
          <div className="header-subtitle">ESRS Compliance Platform</div>
        </div>
      </header>
      <div className="app-body">
        <Sidebar 
          categories={categories} 
          onQuestionSelect={handleQuestionSelect}
          selectedQuestion={selectedQuestion}
          loading={loading}
        />
        <MainPanel 
          selectedQuestion={selectedQuestion}
        />
      </div>
    </div>
  );
}

export default App;