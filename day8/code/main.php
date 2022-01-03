<?php

function splitLetters($raw) {
	$inputArr = explode(' ', $raw);
	$result = [];
	foreach ($inputArr as $word) {
		$number = [];
		foreach (str_split($word) as $letter) {
			$number[$letter] = true;
		}
		$result[] = $number;
	}
	return $result;
}

$tasks = [];
$counter1478 = 0;
$total = 0;

while ($line = trim(fgets(STDIN))) {
	[$input, $output] = explode(' | ', $line, 2);
	$inputSets = splitLetters($input);
	$outputSets = splitLetters($output);
	$code = [];

	foreach ($inputSets as $number) {
		if (count($number) == 2) {
			$code[1] = $number;
		}

		if (count($number) == 4) {
			$code[4] = $number;
		}

		if (count($number) == 3) {
			$code[7] = $number;
		}

		if (count($number) == 7) {
			$code[8] = $number;
		}
	}

	foreach ($inputSets as $idx => $number) {
		if (count($number) == 6) {
			if (array_intersect_assoc($number, $code[4]) == $code[4]) {
				$code[9] = $number;
			} elseif (array_intersect_assoc($number, $code[1]) == $code[1]) {
				$code[0] = $number;
			} else {
				$code[6] = $number;
			}
		}

		if (count($number) == 5) {
			if (array_intersect_assoc($number, $code[1]) == $code[1]) {
				$code[3] = $number;
			} elseif (count(array_intersect_assoc($number, $code[4])) == 2) {
				$code[2] = $number;
			} else {
				$code[5] = $number;
			}
		}
	}

	$outputNum = 0;
	foreach ($outputSets as $number) {
		foreach ([1, 4, 7, 8] as $idx) {
			if ($number == $code[$idx]) {
				$counter1478++;
			}
		}

		$outputNum *= 10;
		foreach ($code as $idx => $digit) {
			if ($number == $digit) {
				$outputNum += $idx;
			}
		}
	}

	$total += $outputNum;
}

if ($argv[1] == 1) {
	echo $counter1478, "\n";
} else {
	echo $total, "\n";
}
