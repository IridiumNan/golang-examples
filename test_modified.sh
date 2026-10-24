#!/usr/bin/env bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Helper function to check command execution status
check_error() {
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "${RED}[ERROR] Test failed with exit code $status${NC}"
        return $status
    else
        echo -e "${GREEN}[SUCCESS] Passed${NC}"
    fi
}

echo -e "${BLUE}===== CHECKING MODIFIED GO FILES =====${NC}"

# Get list of modified/added .go files from git status
# Filters for modified (M), added (A), or untracked (??) status line ending in .go
MODIFIED_GO_FILES=$(git status -s | awk '{print $2}' | grep '\.go$')

if [ -z "$MODIFIED_GO_FILES" ]; then
    echo -e "${YELLOW}No modified or new Go files found.${NC}"
    exit 0
fi

echo -e "${CYAN}Found modified Go files:${NC}"
echo "$MODIFIED_GO_FILES"
echo "----------------------------------------"

# Loop through each modified Go file and run the appropriate test/command
for FILE in $MODIFIED_GO_FILES; do
    echo -e "\n${BLUE}----- Testing: $FILE -----${NC}"

    # Check if the file exists (in case it was deleted)
    if [ ! -f "$FILE" ]; then
        echo -e "${YELLOW}File $FILE was deleted or not found. Skipping.${NC}"
        continue
    fi

    # Handle go test files vs regular go run files
    if [[ "$FILE" == *_test.go ]]; then
        DIR=$(dirname "$FILE")
        echo -e "${CYAN}Running go test on package directory: $DIR${NC}"
        go test -v -bench=. -benchmem "./$DIR"
        check_error
    else
        echo -e "${CYAN}Running go run on file: $FILE${NC}"
        go run "./$FILE"
        check_error
    fi
done

echo -e "\n${BLUE}===== TEST RUN COMPLETED =====${NC}"
