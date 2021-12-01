#!/bin/sh

set -e
cd "$(dirname "$0")"

if [ -t 1 ]; then
	BOLD="$(printf '\033[1m')"
	RESET="$(printf '\033[0m')"
	OK="$(printf ' \033[32mOK%s ' "$RESET")"
	FAIL="$(printf '\033[31mFAIL%s' "$RESET")"
else
	BOLD=''
	RESET=''
	OK=' OK '
	FAIL='FAIL'
fi

tmp="$(mktemp -d)"
overall_status=0

cleanup() {
	rm -r "$tmp"
}

trap cleanup EXIT TERM INT

check_day() {
	day="day$1"
	printf ' %s%03d%s |  ' "$BOLD" "$1" "$RESET"
	if ! "$day"/scripts/build.sh >/dev/null 2>&1; then
		overall_status=1
		printf '%s  |   --   |   --   |   --   |   --\n' "$FAIL"
		return
	fi
	printf '%s ' "$OK"
	for part in 1 2; do
		for mode in demo part; do
			if ! "$day"/scripts/run.sh "$mode" "$part" > "$tmp/out" 2>/dev/null ; then
				overall_status=1
				res="$FAIL"
			elif ! cmp -s "$day/out/${mode}${part}.txt" "$tmp/out"; then
				overall_status=1
				res="$FAIL"
			else
				res="$OK"
			fi
			printf ' |  %s ' "$res"
		done
	done
	printf '\n'
}

printf ' %sday%s | %sbuilds%s | %sdemo 1%s | %spart 1%s | %sdemo 2%s | %spart 2%s\n' \
	"$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET" "$BOLD" "$RESET" 
printf ' --- | ------ | ------ | ------ | ------ | ------\n'

if [ -n "$1" ]; then
	while [ -n "$1" ]; do
		check_day "$1"
		shift
	done
else
	for n in $(seq 1 25); do
		if [ -d "./day${n}" ]; then
			check_day "$n"
		fi
	done
fi

exit "$overall_status"
