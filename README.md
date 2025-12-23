# Smart Task Manager (Full Stack)

A full-stack **Smart Task Management System** consisting of:

* **Backend:** Node.js + Express + PostgreSQL (Supabase)
* **Frontend:** Flutter (Web / Android)
* **Deployment:** Backend on Render, Database on Supabase

The system supports smart task classification, filtering, pagination, audit logging, and a Flutter dashboard UI.

---

## Repository Structure

```
SMART-TASK-MANAGER
│
├── backend
│   ├── node_modules
│   ├── src
│   │   ├── controllers
│   │   ├── db
│   │   │   └── db.js
│   │   ├── routes
│   │   │   └── task.routes.js
│   │   ├── services
│   │   │   ├── classification.service.js
│   │   │   └── taskHistory.service.js
│   │   ├── utils
│   │   └── server.js
│   ├── tests
│   │   ├── tasks.test.js
│   │   └── classification.test.js
│   ├── .env
│   ├── .gitignore
│   ├── package.json
│   └── package-lock.json
│
├── frontend
│   ├── lib
│   │   ├── main.dart
│   │   ├── models
│   │   ├── services
│   │   └── screens
│   ├── test
│   ├── web
│   ├── android
│   ├── ios
│   ├── windows
│   ├── macos
│   ├── linux
│   ├── pubspec.yaml
│   ├── pubspec.lock
│   └── .gitignore
│
└── README.md
```

---

## Prerequisites

Make sure the following are installed on your system:

### Backend

* Node.js (v18 or later)
* npm
* PostgreSQL (Supabase account)

### Frontend

* Flutter SDK (stable)
* Dart SDK (comes with Flutter)
* Chrome (for Flutter web)
* Android Studio (optional, for Android SDK)

Verify installations:

```bash
node -v
npm -v
flutter --version
```

---

## Backend Setup (Node.js + Express)

### 1. Navigate to Backend

```bash
cd backend
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Environment Variables

Create a `.env` file inside `backend/`:

```env
PORT=5000
DATABASE_URL=postgresql://<username>:<password>@<host>:<port>/postgres
```

⚠️ Use **Supabase Session Pooler URL** for production (IPv4 compatible).

---

### 4. Database Setup (Supabase)

Run the following SQL in Supabase SQL Editor:

```sql
CREATE TABLE tasks (
  id uuid PRIMARY KEY,
  title text NOT NULL,
  description text,
  category text,
  priority text,
  status text,
  assigned_to text,
  due_date timestamp,
  extracted_entities jsonb,
  suggested_actions jsonb,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

CREATE TABLE task_history (
  id uuid PRIMARY KEY,
  task_id uuid REFERENCES tasks(id),
  action text,
  old_value jsonb,
  new_value jsonb,
  changed_by text,
  changed_at timestamp DEFAULT now()
);
```

---

### 5. Run Backend Locally

```bash
npm run dev
```

Server runs at:

```
http://localhost:5000
```

---

### 6. Run Backend Tests

```bash
npm test
```

✔ Includes unit tests for:

* Task CRUD APIs
* Smart classification logic

---

## Backend API Overview

### Base URL (Production)

```
https://smart-task-manager-wqa7.onrender.com
```

### Endpoints

| Method | Endpoint         | Description                     |
| ------ | ---------------- | ------------------------------- |
| GET    | `/api/tasks`     | Get tasks (pagination, filters) |
| POST   | `/api/tasks`     | Create task                     |
| GET    | `/api/tasks/:id` | Get task by ID                  |
| PATCH  | `/api/tasks/:id` | Update task                     |
| DELETE | `/api/tasks/:id` | Delete task                     |

---

## Frontend Setup (Flutter)

### 1. Navigate to Frontend

```bash
cd frontend
```

### 2. Get Dependencies

```bash
flutter pub get
```

---

### 3. Configure API URL

Inside Flutter service file (example):

```dart
const String baseUrl =
    "https://smart-task-manager-wqa7.onrender.com/api/tasks";
```

---

### 4. Run Flutter Web

```bash
flutter run -d chrome
```

---

### 5. (Optional) Run Android App

Make sure Android SDK is installed.

```bash
flutter doctor
flutter run
```

---

## Flutter Features Implemented

* Task list dashboard
* Add new task
* Delete task
* Status badges
* Priority indicators
* Filter by task status
* Clean Material UI layout

---

## Deployment

### Backend

* Hosted on **Render**
* Auto-detects port via `process.env.PORT`
* Uses Supabase PostgreSQL

### Frontend

* Runs locally or can be deployed to:

  * Firebase Hosting
  * Netlify
  * Vercel (Flutter Web build)

---

## Screenshots

![Flutter Web Interface](assets\image1.png)

---

## Git & Commits

* Separate backend and frontend folders
* Meaningful commit history (10+ commits)
* `.env` files excluded via `.gitignore`

---

## Final Status

✔ Backend complete
✔ Frontend complete
✔ Database schema ready
✔ API tested
✔ Unit tests implemented
✔ Deployed on Render
✔ Flutter dashboard implemented

---

## Notes

* Supabase Session Pooler is used for production stability
* SSL enabled for database connections
* Pagination and filtering handled server-side
* Smart task classification uses keyword-based logic
