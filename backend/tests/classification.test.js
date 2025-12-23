const { classifyTask } = require("../src/services/classification.service");

describe("Task Classification Logic", () => {

  test("should classify technical bug tasks correctly", () => {
    const result = classifyTask(
      "Fix login bug",
      "Server error when user logs in"
    );

    expect(result.category).toBe("technical");
    expect(result.priority).toBe("low");
    expect(result.extracted_entities).toContain("server");
  });

  test("should mark urgent tasks as high priority", () => {
    const result = classifyTask(
      "Urgent client issue",
      "Client needs fix today"
    );

    expect(result.priority).toBe("high");
    expect(result.suggested_actions).toContain("Notify user immediately");
  });

  test("should detect meetings correctly", () => {
    const result = classifyTask(
      "Client meeting",
      "Schedule call with client"
    );

    expect(result.category).toBe("meeting");
    expect(result.extracted_entities).toContain("client");
  });

});
