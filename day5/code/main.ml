open Hashtbl
open Scanf
open Printf
open Stdlib
open Sys

let table = Hashtbl.create 100000;;
let part = if Sys.argv.(1) = "1" then 1 else 2;;

let continue = ref true;;
while !continue do
    try
        let (x1, y1, x2, y2) = scanf "%d,%d -> %d,%d\n" (fun x1 y1 x2 y2 -> (x1, y1, x2, y2)) in (
            if x1 = x2 then
                for y = (min y1 y2) to (max y1 y2) do
                    match Hashtbl.find_opt table (x1, y) with
                    | Some count -> Hashtbl.replace table (x1, y) (count + 1)
                    | None -> Hashtbl.replace table (x1, y) 1
                done
            else if y1 = y2 then
                for x = (min x1 x2) to (max x1 x2) do
                    match Hashtbl.find_opt table (x, y1) with
                    | Some count -> Hashtbl.replace table (x, y1) (count + 1)
                    | None -> Hashtbl.replace table (x, y1) 1
                done
            else if part = 2 then
                let (x1, y1, x2, y2) = if x1 < x2 then
                    (x1, y1, x2, y2)
                else
                    (x2, y2, x1, y1)
                in
                if y1 < y2 then
                    for shift = 0 to y2 - y1 do
                        match Hashtbl.find_opt table (x1 + shift, y1 + shift) with
                        | Some count -> Hashtbl.replace table (x1 + shift, y1 + shift) (count + 1)
                        | None -> Hashtbl.replace table (x1 + shift, y1 + shift) 1
                    done
                else
                    for shift = 0 to y1 - y2 do
                        match Hashtbl.find_opt table (x2 - shift, y2 + shift) with
                        | Some count -> Hashtbl.replace table (x2 - shift, y2 + shift) (count + 1)
                        | None -> Hashtbl.replace table (x2 - shift, y2 + shift) 1
                    done
        );
    with
        End_of_file -> continue := false;
done;;

let ans = Hashtbl.fold (fun (_, _) c a -> if c > 1 then a + 1 else a) table 0;;

Printf.printf "%d\n" ans;;
