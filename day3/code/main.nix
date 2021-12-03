with builtins; { part, filename }: let
  lib = (import <nixpkgs> {}).lib;

  binToPosNegList = bin: map
    (c: if c == "0" then -1 else 1)
    (lib.stringToCharacters bin);

  binToList = bin: map
    (c: if c == "0" then 0 else 1)
    (lib.stringToCharacters bin);

  listToPosNegList = map (c: if c == 0 then -1 else c);

  sumLists = lib.zipListsWith (a: b: a + b);
  sumAllLists = lists: lib.foldr sumLists (head lists) (tail lists);

  constructBinary = (let
    revConstructBinary = list:
      if list == []
      then 0
      else (head list) + (revConstructBinary (tail list)) * 2;
    in list: revConstructBinary (lib.reverseList list)
  );

  mostCommon = map (n: if n < 0 then 0 else 1);
  leastCommon = map (n: if n >= 0 then 0 else 1);

  sum = input: sumAllLists (map binToPosNegList input);
  gamma = input: constructBinary (mostCommon (sum input));
  epsilon = input: constructBinary (leastCommon (sum input));
  part1 = input: gamma input * epsilon input;

  filterStep = (mode: bitN: lists: let
    pattern = (mode (sumAllLists (map listToPosNegList lists)));
  in
    if length lists == 1
    then head lists
    else filterStep
      mode
      (bitN + 1)
      (filter (list: (elemAt list bitN) == (elemAt pattern bitN)) lists));

  rating = (mode: input: let
    lists = map binToList input;
    bin = filterStep mode 0 lists;
  in
    constructBinary bin);

  oxygenRating = rating mostCommon;
  scrubberRating = rating leastCommon;
  part2 = input: oxygenRating input * scrubberRating input;

  input = filter
    (s: typeOf s == "string" && s != "")
    (split "\n" (readFile filename));
in
  (if part == 1 then part1 else part2) input
