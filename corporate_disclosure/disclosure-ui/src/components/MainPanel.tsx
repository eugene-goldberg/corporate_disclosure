import React, { useState, useEffect } from 'react';
import { Send, Loader2, FileText } from 'lucide-react';
import { Question, QuestionRequest } from '../types';
import { generateAnswer } from '../services/api';
import './MainPanel.css';

interface MainPanelProps {
  selectedQuestion: Question | null;
}

const MainPanel: React.FC<MainPanelProps> = ({ selectedQuestion }) => {
  const [answer, setAnswer] = useState<string>('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [processingTime, setProcessingTime] = useState<number | null>(null);

  // Reset answer when question changes
  useEffect(() => {
    setAnswer('');
    setError(null);
    setProcessingTime(null);
  }, [selectedQuestion]);

  const handleGenerateAnswer = async () => {
    if (!selectedQuestion) return;

    setLoading(true);
    setError(null);
    
    try {
      const request: QuestionRequest = {
        question: selectedQuestion.question,
        year: 2024,
        include_sql: true,
        include_reasoning: true,
      };

      const response = await generateAnswer(request);
      setAnswer(response.answer);
      setProcessingTime(response.processing_time);
    } catch (err) {
      setError('Failed to generate answer. Please try again.');
      console.error('Error generating answer:', err);
    } finally {
      setLoading(false);
    }
  };

  if (!selectedQuestion) {
    return (
      <div className="main-panel">
        <div className="empty-state">
          <FileText size={48} />
          <h3>Select a Question</h3>
          <p>Choose a disclosure question from the categories on the left to begin.</p>
        </div>
      </div>
    );
  }

  return (
    <div className="main-panel">
      <div className="panel-header">
        <h2>Disclosure Question</h2>
        {processingTime && (
          <span className="processing-time">
            Generated in {processingTime.toFixed(2)}s
          </span>
        )}
      </div>
      
      <div className="question-section">
        <div className="question-label">Selected Question:</div>
        <div className="question-text">{selectedQuestion.question}</div>
      </div>

      <div className="answer-section">
        <div className="answer-controls">
          <button 
            className="generate-button"
            onClick={handleGenerateAnswer}
            disabled={loading}
          >
            {loading ? (
              <>
                <Loader2 className="spinning" size={16} />
                Generating Answer...
              </>
            ) : (
              <>
                <Send size={16} />
                Generate Disclosure Answer
              </>
            )}
          </button>
        </div>

        {error && (
          <div className="error-message">
            {error}
          </div>
        )}

        <div className="answer-editor">
          <textarea
            className="answer-textarea"
            value={answer}
            onChange={(e) => setAnswer(e.target.value)}
            placeholder="Click 'Generate Disclosure Answer' to create a comprehensive response based on your corporate data..."
            rows={20}
          />
        </div>

        <div className="answer-info">
          <p>This answer is generated using AI based on your corporate sustainability data and ESRS disclosure requirements.</p>
        </div>
      </div>
    </div>
  );
};

export default MainPanel;