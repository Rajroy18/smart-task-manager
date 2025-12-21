const request = require("supertest");
const app = require("../src/server");
const pool = require("../src/db/db");

let taskId;

describe("Tasks API", () => {

  // Test 1: GET all tasks
  it("should fetch tasks", async () => {
    const res = await request(app).get("/api/tasks");
    expect(res.statusCode).toBe(200);
    expect(res.body).toHaveProperty("data");
  });

  // Test 2: POST create task
  it("should create a task", async () => {
    const res = await request(app)
      .post("/api/tasks")
      .send({
        title: "Jest Task",
        description: "Created during test",
      });

    expect(res.statusCode).toBe(201);
    expect(res.body).toHaveProperty("id");

    taskId = res.body.id;
  });

  // Test 3: GET task by ID
  it("should fetch task by id", async () => {
    const res = await request(app).get(`/api/tasks/${taskId}`);
    expect(res.statusCode).toBe(200);
    expect(res.body.id).toBe(taskId);
  });

});

// ✅ Close DB connection after tests
afterAll(async () => {
  await pool.end();
});
