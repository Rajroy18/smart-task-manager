function classifyTask(text) {
  const lower = text.toLowerCase();

  // CATEGORY
  let category = "general";

  if (/(meeting|schedule|call|appointment|deadline)/.test(lower)) {
    category = "scheduling";
  } else if (/(payment|invoice|bill|budget|cost|expense)/.test(lower)) {
    category = "finance";
  } else if (/(bug|fix|error|install|repair|maintain)/.test(lower)) {
    category = "technical";
  } else if (/(safety|hazard|inspection|compliance|ppe)/.test(lower)) {
    category = "safety";
  }

  // PRIORITY
  let priority = "low";

  if (/(urgent|asap|immediately|today|critical|emergency)/.test(lower)) {
    priority = "high";
  } else if (/(soon|this week|important)/.test(lower)) {
    priority = "medium";
  }

  return { category, priority };
}

module.exports = { classifyTask };
