#!/bin/bash
# Genererer krav/krav-oversikt.md basert på alle .feature filer

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
KRAV_DIR="$REPO_ROOT/krav"
OUTPUT_FILE="$KRAV_DIR/krav-oversikt.md"

{
echo "# Kravoversikt"
echo ""
echo "Generert oversikt over alle BDD-krav i prosjektet."
echo ""

current_domain=""

find "$KRAV_DIR" -name "*.feature" -type f | sort | while read file; do
    # Get relative path from krav/
    relpath="${file#$KRAV_DIR/}"
    dirpath=$(dirname "$relpath")

    # Extract path components
    IFS='/' read -ra parts <<< "$dirpath"

    domain="${parts[0]:-}"
    subdomain="${parts[1]:-}"
    capability="${parts[2]:-}"

    # Get feature name from file
    feature_name=$(grep -m1 "^[[:space:]]*Egenskap:" "$file" | sed 's/.*Egenskap:[[:space:]]*//')

    # Get tags
    tags=$(grep -m1 "^@" "$file" | tr -d '\r' || echo "")

    # Print domain header if changed
    if [ "$domain" != "$current_domain" ]; then
        current_domain="$domain"
        echo ""
        echo "## $domain"
        echo ""
        echo "| ID | Feature | Sub-domene | Kapabilitet | Tags | Fil |"
        echo "|----|---------|------------|-------------|------|-----|"
    fi

    # Build ID from path components
    id_parts=()
    for part in "${parts[@]}"; do
        abbrev=$(echo "$part" | sed 's/^[0-9]* //' | cut -c1-3 | tr '[:lower:]' '[:upper:]')
        if [ -n "$abbrev" ]; then
            id_parts+=("$abbrev")
        fi
    done

    # Get number from last directory
    last_dir="${parts[-1]}"
    last_num=$(echo "$last_dir" | grep -oE "^[0-9]+")

    # Build ID
    id=$(IFS='-'; echo "${id_parts[*]}")
    if [ -n "$last_num" ]; then
        id="$id-$last_num"
    fi

    # URL-encode the path (replace spaces with %20)
    encoded_path=$(echo "$relpath" | sed 's/ /%20/g')

    # Filename for display
    filename=$(basename "$file")

    echo "| $id | $feature_name | $subdomain | $capability | $tags | [$filename]($encoded_path) |"
done

echo ""
echo "## Statistikk"
echo ""
total=$(find "$KRAV_DIR" -name "*.feature" | wc -l)
levert=$(grep -rl "@levert" "$KRAV_DIR" --include="*.feature" 2>/dev/null | wc -l)
skip=$(grep -rl "@skip" "$KRAV_DIR" --include="*.feature" 2>/dev/null | wc -l)
echo "- Totalt: $total"
echo "- Levert: $levert"
echo "- Skip: $skip"
} > "$OUTPUT_FILE"

echo "Generert $OUTPUT_FILE"
