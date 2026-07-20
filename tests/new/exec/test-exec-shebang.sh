#!/bin/sh
# Test: Exec and shebang
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require_helper true

# Create test script with shebang
TEST_SCRIPT=$(tmpdir "test-script.sh")
cat > "$TEST_SCRIPT" <<'EOF'
#!/bin/sh
echo "shebang works"
EOF
chmod +x "$TEST_SCRIPT"

# Test 1: Shebang script executes
RESULT=$(${PROOT} "$TEST_SCRIPT" 2>/dev/null)
is "$RESULT" "shebang works" "shebang script executes"

# Test 2: argv[0] is correct
TEST_SCRIPT2=$(tmpdir "test-argv0.sh")
cat > "$TEST_SCRIPT2" <<'EOF'
#!/bin/sh
echo "$0"
EOF
chmod +x "$TEST_SCRIPT2"

RESULT=$(${PROOT} "$TEST_SCRIPT2" 2>/dev/null)
like "$RESULT" "test-argv0.sh" "argv[0] is correct"

# Cleanup
rm -f "$TEST_SCRIPT" "$TEST_SCRIPT2"
plan 2
