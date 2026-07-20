#!/bin/sh
# Test helpers for PRoot test suite
# Source this file in each test: . "$(dirname "$0")/../helpers.sh"

# Test state
TEST_NUM=0
TEST_PLAN=0
TEST_PASS=0
TEST_FAIL=0
TEST_SKIP=0

# TAP output
plan() {
    TEST_PLAN=$1
    echo "1..${TEST_PLAN}"
}

ok() {
    TEST_NUM=$((TEST_NUM + 1))
    TEST_PASS=$((TEST_PASS + 1))
    echo "ok ${TEST_NUM} - $1"
}

fail() {
    TEST_NUM=$((TEST_NUM + 1))
    TEST_FAIL=$((TEST_FAIL + 1))
    echo "not ok ${TEST_NUM} - $1"
}

skip() {
    TEST_NUM=$((TEST_NUM + 1))
    TEST_SKIP=$((TEST_SKIP + 1))
    echo "ok ${TEST_NUM} - SKIP: $1"
}

# Skip entire test if condition is true
skip_if() {
    if eval "$1"; then
        exit 125
    fi
}

# Skip entire test if command not found
require() {
    local cmd="$1"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        exit 125
    fi
}

# Assert equality
is() {
    local got="$1"
    local expected="$2"
    local desc="${3:-}"
    if [ "$got" = "$expected" ]; then
        ok "$desc"
    else
        fail "$desc: expected '${expected}', got '${got}'"
    fi
}

# Assert command succeeds
is_ok() {
    local desc="${1:-command succeeded}"
    if eval "$2" >/dev/null 2>&1; then
        ok "$desc"
    else
        fail "$desc: command failed"
    fi
}

# Assert command fails
is_fail() {
    local desc="${1:-command failed}"
    if eval "$2" >/dev/null 2>&1; then
        fail "$desc: command should have failed"
    else
        ok "$desc"
    fi
}

# Assert output matches regex
like() {
    local got="$1"
    local pattern="$2"
    local desc="${3:-}"
    if echo "$got" | grep -q "$pattern"; then
        ok "$desc"
    else
        fail "$desc: output '$got' does not match pattern '$pattern'"
    fi
}

# Assert file exists
file_exists() {
    local path="$1"
    local desc="${2:-file exists: $path}"
    if [ -f "$path" ]; then
        ok "$desc"
    else
        fail "$desc"
    fi
}

# Assert directory exists
dir_exists() {
    local path="$1"
    local desc="${2:-dir exists: $path}"
    if [ -d "$path" ]; then
        ok "$desc"
    else
        fail "$desc"
    fi
}

# Assert exit code
exit_code() {
    local expected="$1"
    local desc="$2"
    shift 2
    local actual=0
    "$@" 2>/dev/null || actual=$?
    if [ "$actual" -eq "$expected" ]; then
        ok "$desc"
    else
        fail "$desc: expected exit $expected, got $actual"
    fi
}

# Create temp directory
tmpdir() {
    echo "${TMPDIR:-/tmp}/proot-test-$$-$(date +%s)-$1"
}

# Cleanup
cleanup() {
    if [ -n "$TEST_TMPDIR" ] && [ -d "$TEST_TMPDIR" ]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

# Setup test environment
setup_test() {
    TEST_TMPDIR=$(mktemp -d "${TMPDIR:-/tmp}/proot-test-XXXXXXXX")
    trap cleanup EXIT
}

# Helper binaries
ROOTFS_BIN="${ROOTFS}/bin"

# Check if helper binary exists
require_helper() {
    local name="$1"
    if [ ! -x "${ROOTFS_BIN}/${name}" ]; then
        skip "helper not built: ${name}"
        return 0
    fi
    return 1
}
