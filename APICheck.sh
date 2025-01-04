
#!/bin/bash

# Define the directory to search
SEARCH_DIR="api/"

# Define the file pattern to search for (e.g., *.sql for SQL files, *.sh for shell scripts)
FILE_PATTERN="index.os"
VERBOSE="${1}"

# Use `find` to locate the files and iterate over them
find "${SEARCH_DIR}" -type f -name "${FILE_PATTERN}" | while read -r FILE; do
    # Execute the found file
    echo "Testing: ${FILE}"

    if [ "${VERBOSE}" == "-v" ]; then
        "${FILE}"
    else
        "${FILE}" 1>/dev/null
    fi
done

