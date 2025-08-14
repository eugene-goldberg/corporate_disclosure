import React, { useState } from 'react';
import { ChevronDown, ChevronRight, FileText, Folder } from 'lucide-react';
import { Category, Question } from '../types';
import './Sidebar.css';

interface SidebarProps {
  categories: Category[];
  onQuestionSelect: (question: Question) => void;
  selectedQuestion: Question | null;
  loading: boolean;
}

const Sidebar: React.FC<SidebarProps> = ({ categories, onQuestionSelect, selectedQuestion, loading }) => {
  const [expandedCategories, setExpandedCategories] = useState<Set<string>>(new Set());

  const toggleCategory = (categoryName: string) => {
    const newExpanded = new Set(expandedCategories);
    if (newExpanded.has(categoryName)) {
      newExpanded.delete(categoryName);
    } else {
      newExpanded.add(categoryName);
    }
    setExpandedCategories(newExpanded);
  };

  const formatCategoryName = (name: string) => {
    return name
      .split('_')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  };

  if (loading) {
    return (
      <div className="sidebar">
        <div className="sidebar-header">
          <h2>Disclosure Categories</h2>
        </div>
        <div className="sidebar-content">
          <div className="loading">Loading categories...</div>
        </div>
      </div>
    );
  }

  return (
    <div className="sidebar">
      <div className="sidebar-header">
        <h2>Disclosure Categories</h2>
      </div>
      <div className="sidebar-content">
        {categories.map((category) => {
          const isExpanded = expandedCategories.has(category.name);
          
          return (
            <div key={category.name} className="category-section">
              <div 
                className="category-header"
                onClick={() => toggleCategory(category.name)}
              >
                <div className="category-icon">
                  {isExpanded ? <ChevronDown size={16} /> : <ChevronRight size={16} />}
                  <Folder size={16} />
                </div>
                <span className="category-name">{formatCategoryName(category.name)}</span>
                <span className="category-count">{category.count}</span>
              </div>
              
              {isExpanded && (
                <div className="questions-list">
                  {category.questions.map((question, index) => (
                    <div
                      key={index}
                      className={`question-item ${selectedQuestion?.question === question.question ? 'selected' : ''}`}
                      onClick={() => onQuestionSelect(question)}
                    >
                      <FileText size={14} />
                      <span className="question-text">{question.question}</span>
                    </div>
                  ))}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default Sidebar;