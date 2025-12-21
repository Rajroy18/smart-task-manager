# Smart Task Manager API

A production-ready **Task Management REST API** built with **Node.js, Express, and PostgreSQL (Supabase)**.  
The API supports full CRUD operations, filtering, pagination, and is deployed live on **Render**.

---

## 🚀 Live Deployment

**Base URL:**  
https://smart-task-manager-wqa7.onrender.com

---

## 🛠 Tech Stack

- **Backend:** Node.js, Express.js
- **Database:** PostgreSQL (Supabase)
- **ORM/Driver:** pg
- **Deployment:** Render
- **API Testing:** Thunder Client (VS Code extension)

---

## 📦 Features

- Create, read, update, and delete tasks
- Pagination support (`page`, `limit`)
- Filtering by task status
- Proper HTTP status codes & error handling
- Environment-based configuration
- Deployed and publicly accessible API

---

## 🗂 Database Schema

```sql
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  category TEXT DEFAULT 'general',
  priority TEXT DEFAULT 'low',
  status TEXT DEFAULT 'pending',
  assigned_to TEXT,
  due_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🔗 API Endpoints

### 1️⃣ Get All Tasks (with pagination)

```
GET /api/tasks?page=1&limit=5
```

**Response:**
```json
{
  "total": 2,
  "page": 1,
  "pages": 1,
  "data": [
    {
      "id": "uuid",
      "title": "Sample Task",
      "status": "pending"
    }
  ]
}
```

---

### 2️⃣ Create a Task

```
POST /api/tasks
```

**Body (JSON):**
```json
{
  "title": "New Task",
  "description": "Task description",
  "category": "general",
  "priority": "low"
}
```

**Status:** `201 Created`

---

### 3️⃣ Get Task by ID

```
GET /api/tasks/:id
```

**Status:** `200 OK` | `404 Not Found`

---

### 4️⃣ Update Task (Partial Update)

```
PATCH /api/tasks/:id
```

**Body (JSON):**
```json
{
  "status": "completed",
  "priority": "high"
}
```

**Status:** `200 OK`

---

### 5️⃣ Delete Task

```
DELETE /api/tasks/:id
```

**Response:**
```json
{
  "message": "Task deleted successfully"
}
```

---

## ❌ Error Handling Examples

### Missing required field

```json
{
  "error": "Title is required"
}
```

**Status:** `400 Bad Request`

---

### Task not found

```json
{
  "error": "Task not found"
}
```

**Status:** `404 Not Found`

---

## 🧪 API Testing

All endpoints were tested using **Thunder Client** in VS Code.

Tested scenarios include:
- Create task
- Fetch tasks with pagination
- Update task status
- Delete task
- Error cases (invalid ID, missing fields)

---

## ⚙️ Environment Variables

Create a `.env` file locally:

```env
PORT=5000
DATABASE_URL=postgresql://<username>:<password>@<host>:<port>/postgres
```

⚠️ `.env` is excluded from GitHub for security reasons.

---

## ▶️ Run Locally

```bash
npm install
npm run dev
```

Server will start at:
```
http://localhost:5000
```

---

## 📌 Notes

- Supabase Session Pooler is used for production deployment
- SSL is enabled for database connections
- Render automatically assigns the runtime port

---

## 👤 Author

**Shubhra Samanta**  
Backend Developer

---

## ✅ Status

✔ Backend complete  
✔ Deployed & tested  
✔ Submission-ready

