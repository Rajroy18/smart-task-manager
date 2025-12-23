function classifyTask(title = "", description = "") {
  const text = `${title} ${description}`.toLowerCase();

  // CATEGORY
  let category = "general";
  if (text.includes("bug") || text.includes("error") || text.includes("fix")) {
    category = "technical";
  } else if (text.includes("meeting") || text.includes("call")) {
    category = "meeting";
  }

  // PRIORITY
  let priority = "low";
  if (text.includes("urgent") || text.includes("asap") || text.includes("today")) {
    priority = "high";
  } else if (text.includes("soon")) {
    priority = "medium";
  }

  // ENTITIES
  const extracted_entities = [];
  if (text.includes("email")) extracted_entities.push("email");
  if (text.includes("client")) extracted_entities.push("client");
  if (text.includes("server")) extracted_entities.push("server");

  // ACTIONS
  const suggested_actions = [];
  if (priority === "high") suggested_actions.push("Notify user immediately");
  if (category === "technical") suggested_actions.push("Assign to developer");

  return {
    category,
    priority,
    extracted_entities,
    suggested_actions
  };
}

module.exports = { classifyTask };
