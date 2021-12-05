# Advent of Code 2021: 5/25 langs

I’ll try to solve this Advent of Code using different language for each day.
Any programs needed to run the code will be available via dev shell in the `flake.nix`.

## Languages

| Day | Language                 | Link               |
| :-: | ------------------------ | ------------------ |
|  1  | GNU Assembler (w/o libc) | [`./day1/`](/day1) |
|  2  | GNU Awk                  | [`./day2/`](/day2) |
|  3  | Nix                      | [`./day3/`](/day3) |
|  4  | Racket                   | [`./day4/`](/day4) |
|  5  | OCaml                    | [`./day5/`](/day5) |

## `check.sh`

You can use `check.sh` script in the root directory of the repo to run all tests for one or every day.

```
$ ./check.sh      # Run all tests for every available day
$ ./check.sh 2    # Run all tests for the second day
$ ./check.sh 1 3  # Run all tests for the first and the third day
```

This script will exit with non-zero status if any of the checks failed.

## Directory structure

In each `day*` directory there are following files and subdirectories:

|  Path                | Contents                                     |
| -------------------- | -------------------------------------------- |
| `./README.md`        | Description & various info                   |
| `./in/`              | Input files for the task                     |
| `./in/demo1.txt`     | Example for the first part                   |
| `./in/demo2.txt`     | Example for the second part                  |
| `./in/part1.txt`     | Input file for the first part                |
| `./in/part2.txt`     | Input file for the second part               |
| `./out/*.txt`        | Correct answers for the corresponding inputs |
| `./code/`            | Code of the solution                         |
| `./build/`           | Build artifacts                              |
| `./build/.keep`      | Empty file, required to commit `./build/`    |
| `./scripts/`         | Scripts for building & running the solution  |
| `./scripts/build.sh` | Build the solution                           |
| `./scripts/run.sh`   | Run the solution with specified input        |

## How to use `run.sh`

```
$ dayX/scripts/run.sh demo 1  # Run the first on the example
$ dayX/scripts/run.sh part 1  # Run the first part on the real input
$ dayX/scripts/run.sh demo 2  # Run the second part on the example
$ dayX/scripts/run.sh part 2  # Run the second part on the real input
```
