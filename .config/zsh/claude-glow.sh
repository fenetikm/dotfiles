#!/usr/bin/env zsh

# claude-glow: Send a question to Claude, render with glow

# Function to display usage
show_usage() {
  echo "Usage: claude-glow [question without quotes]"
  echo "       echo \"question\" | claude-glow"
  echo "       claude-glow  (then type multi-line query, end with Ctrl+D)"
  echo ""
  echo "Examples:"
  echo "  claude-glow How do I create a REST API in Node.js?"
  echo "  echo \"Explain Docker containers\" | claude-glow"
  echo "  claude-glow  # Interactive multi-line mode"
}

if [[ $# -gt 0 ]]; then
  # The query is in the args
  query="$*"
elif [[ ! -t 0 ]]; then
  # Query piped in
  query=$(cat)
else
  # No args, interactive multi-line mode
  echo "Question (Ctrl+D to end):"
  query=$(cat)
fi

if [[ -z "$query" ]]; then
  show_usage
  exit 1
fi

temp_file=$(mktemp /tmp/claude-response.XXXXXX)

echo "Asking..." >&2
if ! claude -p "$query" > "$temp_file" 2>&1; then
  echo "Error: Claude CLI failed. Check authentication or try running 'claude' interactively first." >&2
  rm "$temp_file"
  exit 1
fi

# Check if we got any output
if [[ ! -s "$temp_file" ]]; then
  echo "Error: No response from Claude CLI" >&2
  rm "$temp_file"
  exit 1
fi

cat "$temp_file" | glow

# Clean up temp file
rm "$temp_file"
