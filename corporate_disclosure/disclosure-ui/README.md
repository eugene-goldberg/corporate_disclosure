# Corporate Disclosure Management UI

A React-based web application for managing ESRS corporate disclosure questions and generating AI-powered answers.

## Features

- **Category Browser**: Navigate through disclosure categories and questions
- **Question Selection**: Click on any question to view details
- **AI Answer Generation**: Generate comprehensive disclosure answers using corporate data
- **Real-time Processing**: See processing time for each generated answer
- **Editable Responses**: Modify generated answers as needed

## Prerequisites

- Node.js 16+ and npm
- The Corporate Disclosure API running on port 8001

## Installation

1. Install dependencies:
```bash
npm install
```

2. Start the development server:
```bash
npm start
```

The app will open at http://localhost:3000

## Configuration

The app expects the API to be running at http://localhost:8001. To change this:

1. Update the proxy in `package.json`
2. Or set the `REACT_APP_API_URL` environment variable

## Usage

1. **Browse Categories**: Use the left sidebar to explore disclosure categories
2. **Select a Question**: Click on any question to view it in the main panel
3. **Generate Answer**: Click "Generate Disclosure Answer" to create an AI response
4. **Edit Response**: The generated answer can be edited in the text area

## Technology Stack

- React 18 with TypeScript
- Axios for API communication
- Lucide React for icons
- CSS for styling

## API Integration

The app connects to the Corporate Disclosure API v2 which provides:
- `/questions` - Get all disclosure questions by category
- `/answer` - Generate AI-powered answers for selected questions