#!/usr/bin/env bash
# Validate every skill in skills/. Run locally or in CI.
# Checks: SKILL.md exists, has framed frontmatter, name matches the directory,
# description is non-empty, and the file stays under 500 lines.

set -uo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$root/skills"
errors=0
count=0

for dir in "$skills_dir"/*/; do
  name="$(basename "$dir")"
  f="$dir/SKILL.md"
  count=$((count + 1))

  if [[ ! -f "$f" ]]; then
    echo "FAIL $name: no SKILL.md"; errors=$((errors + 1)); continue
  fi

  # Frontmatter must open on line 1 and close with a second ---
  if [[ "$(head -n1 "$f")" != "---" ]]; then
    echo "FAIL $name: frontmatter must start with --- on line 1"; errors=$((errors + 1))
  fi
  if [[ "$(grep -c '^---$' "$f")" -lt 2 ]]; then
    echo "FAIL $name: frontmatter not closed with ---"; errors=$((errors + 1))
  fi

  fn="$(grep -m1 '^name:' "$f" | sed 's/name:[[:space:]]*//')"
  if [[ "$fn" != "$name" ]]; then
    echo "FAIL $name: name '$fn' does not match directory"; errors=$((errors + 1))
  fi

  desc="$(grep -m1 '^description:' "$f" | sed 's/description:[[:space:]]*//')"
  if [[ -z "$desc" ]]; then
    echo "FAIL $name: empty or missing description"; errors=$((errors + 1))
  fi

  lines="$(wc -l < "$f" | tr -d ' ')"
  if [[ "$lines" -gt 300 ]]; then
    echo "FAIL $name: $lines lines (max 300 — move lookup tables into reference/)"
    errors=$((errors + 1))
  elif [[ "$lines" -lt 100 ]]; then
    echo "WARN $name: only $lines lines — likely too thin to be worth installing"
  fi

  # Every relative markdown link must resolve.
  while read -r target; do
    [[ -z "$target" ]] && continue
    if [[ ! -e "$dir/$target" ]]; then
      echo "FAIL $name: broken link to $target"; errors=$((errors + 1))
    fi
  done < <(grep -o '](\./[^)]*\|](reference/[^)]*' "$f" | sed 's/^](//')
done

echo "----"
if [[ "$errors" -eq 0 ]]; then
  echo "OK: $count skills passed validation"
  exit 0
else
  echo "FAILED: $errors error(s) across $count skills"
  exit 1
fi
