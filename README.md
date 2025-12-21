# Smart Task Manager API

A production-ready **Task Management REST API** built with **Node.js, Express, and PostgreSQL (Supabase)**.
The application includes smart task classification, audit logging, pagination, filtering, and unit tests, and is deployed live on **Render**.

---

## 🚀 Live Deployment

**Base URL:**
[https://smart-task-manager-wqa7.onrender.com](https://smart-task-manager-wqa7.onrender.com)

---

## 🛠 Tech Stack

* **Backend:** Node.js, Express.js
* **Database:** PostgreSQL (Supabase)
* **Database Driver:** pg
* **Testing:** Jest
* **Deployment:** Render
* **API Testing:** Thunder Client (VS Code)

---

## ✨ Features

* Full CRUD operations for tasks
* Smart auto-classification (category & priority)
* Entity extraction and suggested actions
* Task history (audit log)
* Pagination and filtering
* Robust error handling
* Environment-based configuration
* Unit tests for core logic

---

## 🗂 Database Schema

### Tasks Table

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
```

### Task History Table

```sql
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

## 🔗 API Endpoints

### Get All Tasks (Pagination & Filters)

```
GET /api/tasks?page=1&limit=5&status=pending&priority=high
```

**Response:**

```json
{
  "total": 2,
  "page": 1,
  "pages": 1,
  "data": []
}
```

---

### Create Task

```
POST /api/tasks
```

**Body:**

```json
{
  "title": "Urgent bug fix",
  "description": "Fix server error today"
}
```

---

### Get Task by ID

```
GET /api/tasks/:id
```

---

### Update Task

```
PATCH /api/tasks/:id
```

**Body:**

```json
{
  "status": "completed"
}
```

---

### Delete Task

```
DELETE /api/tasks/:id
```

---

## 🧠 Smart Classification Logic

The API automatically determines:

* **Category** (technical, meeting, general)
* **Priority** (low, medium, high)
* **Extracted entities** (client, server, email)
* **Suggested actions** (notifications, assignment)

This logic is implemented using keyword-based analysis.

---

## 🧪 Testing

Unit tests are implemented using **Jest** to validate classification logic.

Run tests:

```bash
npm test
```

---

## ⚙️ Environment Variables

Create a `.env` file:

```env
PORT=5000
DATABASE_URL=postgresql://<username>:<password>@<host>:<port>/postgres
```

⚠️ Do not commit `.env` to version control.

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

* Supabase session pooler is used for database connections
* SSL is enabled for production
* Render dynamically assigns the runtime port

---

## ✅ Project Status

✔ Backend complete
✔ Smart logic implemented
✔ Unit tested
✔ Deployed and production-ready
