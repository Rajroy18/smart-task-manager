const pool = require("../db/db");

async function logTaskHistory(
  taskId,
  action,
  oldValue = null,
  newValue = null,
  changedBy = "system"
) {
  await pool.query(
    `INSERT INTO task_history
     (id, task_id, action, old_value, new_value, changed_by)
     VALUES (gen_random_uuid(), $1, $2, $3, $4, $5)`,
    [taskId, action, oldValue, newValue, changedBy]
  );
}

module.exports = { logTaskHistory };
