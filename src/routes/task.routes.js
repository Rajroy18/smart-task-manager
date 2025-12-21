const express = require("express");
const { v4: uuidv4 } = require("uuid");
const pool = require("../db/db");
const { classifyTask } = require("../services/classification.service");
const { logTaskHistory } = require("../services/taskHistory.service");


const router = express.Router();

/**
 * POST /api/tasks
 * Create a task
 */
router.post("/", async (req, res) => {
  try {
    const { title, description, status } = req.body;

    if (!title || !description) {
      return res.status(400).json({
        error: "Title and description are required",
      });
    }

    const {
      category,
      priority,
      extracted_entities,
      suggested_actions,
    } = classifyTask(title, description);

    const id = uuidv4();

    const result = await pool.query(
      `INSERT INTO tasks
      (id, title, description, category, priority, status, extracted_entities, suggested_actions, created_at, updated_at)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,now(),now())
      RETURNING *`,
      [
        id,
        title,
        description,
        category,
        priority,
        status || "pending",
        extracted_entities,
        suggested_actions,
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to create task" });
  }
});

/**
 * GET /api/tasks
 * Filters + Pagination
 */
router.get("/", async (req, res) => {
  try {
    const { status, priority, page = 1, limit = 10 } = req.query;

    const filters = [];
    const values = [];

    if (status) {
      values.push(status);
      filters.push(`status = $${values.length}`);
    }

    if (priority) {
      values.push(priority);
      filters.push(`priority = $${values.length}`);
    }

    const whereClause =
      filters.length > 0 ? `WHERE ${filters.join(" AND ")}` : "";

    const offset = (page - 1) * limit;

    const countResult = await pool.query(
      `SELECT COUNT(*) FROM tasks ${whereClause}`,
      values
    );

    const total = Number(countResult.rows[0].count);

    const result = await pool.query(
      `SELECT * FROM tasks
       ${whereClause}
       ORDER BY created_at DESC
       LIMIT $${values.length + 1}
       OFFSET $${values.length + 2}`,
      [...values, limit, offset]
    );

    res.json({
      total,
      page: Number(page),
      pages: Math.ceil(total / limit),
      data: result.rows,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch tasks" });
  }
});

/**
 * GET /api/tasks/:id
 */
router.get("/:id", async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT * FROM tasks WHERE id=$1`,
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Task not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to fetch task" });
  }
});

/**
 * PATCH /api/tasks/:id
 */
router.patch("/:id", async (req, res) => {
  try {
    const { title, description, status } = req.body;

    const existing = await pool.query(
      `SELECT * FROM tasks WHERE id=$1`,
      [req.params.id]
    );

    if (existing.rows.length === 0) {
      return res.status(404).json({ error: "Task not found" });
    }

    const updatedTitle = title || existing.rows[0].title;
    const updatedDescription =
      description || existing.rows[0].description;

    const {
      category,
      priority,
      extracted_entities,
      suggested_actions,
    } = classifyTask(updatedTitle, updatedDescription);

    const result = await pool.query(
      `UPDATE tasks
       SET title=$1,
           description=$2,
           category=$3,
           priority=$4,
           status=$5,
           extracted_entities=$6,
           suggested_actions=$7,
           updated_at=now()
       WHERE id=$8
       RETURNING *`,
      [
        updatedTitle,
        updatedDescription,
        category,
        priority,
        status || existing.rows[0].status,
        extracted_entities,
        suggested_actions,
        req.params.id,
      ]
    );

    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to update task" });
  }
});

/**
 * DELETE /api/tasks/:id
 */
router.delete("/:id", async (req, res) => {
  try {
    const result = await pool.query(
      `DELETE FROM tasks WHERE id=$1 RETURNING *`,
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Task not found" });
    }

    res.json({ message: "Task deleted" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to delete task" });
  }
});

module.exports = router;
