#!/bin/sh
# Test: Symlinks followed through read-only bindings
. "$(dirname "$0")/../../helpers.sh"


skip_if [ ! -x "${PROOT}" ] "proot not built"
require mcookie "mcookie not found"
require echo "echo not found"
require touch "touch not found"
require rm "rm not found"

# Create test files
FOO1=$(tmpdir "ro-symlink-1")
FOO2=$(tmpdir "ro-symlink-2")
FOO3=$(tmpdir "ro-symlink-3")
FOO4=$(tmpdir "ro-symlink-4")

echo "content of FOO1" > "$FOO1"
echo "content of FOO2" > "$FOO2"

ln -s "$FOO1" "$FOO3"  # FOO3 -> FOO1
ln -s "$FOO2" "$FOO4"  # FOO4 -> FOO2

# Test 1: Symlink binding follows through
RESULT=$(${PROOT} -b "${FOO3}:${FOO4}" cat "$FOO2" 2>/dev/null)
like "$RESULT" "^content of FOO1$" "symlink binding follows through"

# Test 2: Reverse symlink binding
RESULT=$(${PROOT} -b "${FOO4}:${FOO3}" cat "$FOO1" 2>/dev/null)
like "$RESULT" "^content of FOO2$" "reverse symlink binding works"

# Test 3: Non-dereference binding (!)
RESULT=$(${PROOT} -b "${FOO3}:${FOO4}!" cat "$FOO2" 2>/dev/null)
like "$RESULT" "^content of FOO2$" "non-dereference binding works"

# Test 4: Multiple bindings with symlink
RESULT=$(${PROOT} -v -1 -b "$FOO1" -b "${FOO3}" cat "$FOO1" 2>/dev/null)
like "$RESULT" "^content of FOO1$" "multiple bindings with symlink work"

# Cleanup
rm -f "$FOO1" "$FOO2" "$FOO3" "$FOO4"
plan 4
