BEGIN {
	x = 0
	depth = 0
	aim = 0
}

/forward/ {
	if (part == 1) {
		x += $2;
	} else {
		x += $2;
		depth += aim * $2;
	}
}

/down/ {
	if (part == 1) {
		depth += $2;
	} else {
		aim += $2;
	}
}

/up/ {
	if (part == 1) {
		depth -= $2;
	} else {
		aim -= $2;
	}
}

END {
	print (x * depth);
}
