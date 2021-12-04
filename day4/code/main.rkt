#lang racket

(define five '(0 1 2 3 4))

(define id (lambda (x) x))

(define all-of
  (lambda (xs)
    (or (not (pair? xs))
        (and (car xs) (all-of (cdr xs))))))

(define any-of
  (lambda (xs)
    (and (pair? xs)
         (or (car xs) (any-of (cdr xs))))))

(define check-board-row
  (lambda (row numbers)
    (all-of (map (lambda (idx) (member (vector-ref row idx) numbers)) five))))

(define check-board-rows
  (lambda (board numbers)
    (any-of (map (lambda (idx) (check-board-row (vector-ref board idx) numbers)) five))))

(define check-board-column
  (lambda (board column-idx numbers)
    (all-of (map (lambda (idx) (member (vector-ref (vector-ref board idx) column-idx) numbers)) five))))

(define check-board-columns
  (lambda (board numbers)
    (any-of (map (lambda (idx) (check-board-column board idx numbers)) five))))

(define check-board
  (lambda (board numbers)
    (or
      (check-board-rows board numbers)
      (check-board-columns board numbers))))

(define score-board
  (lambda (board numbers)
    (letrec ([board-list (map vector->list (vector->list board))]
             [filtered-board (map (lambda (row) (filter (lambda (el) (not (member el numbers))) row)) board-list)]
             [all-cells (flatten filtered-board)])
      (* (car numbers) (foldr + 0 all-cells)))))

(define parse-numbers
  (lambda (raw-numbers)
    (map string->number (string-split raw-numbers ","))))

(define parse-board-row
  (lambda (raw-row)
    (list->vector (filter id (map string->number (string-split raw-row " "))))))

(define read-board
  (lambda ()
    (if 
      (eof-object? (read-line)) ; Skipping an empty line
      '()
      (list->vector (map (lambda (idx) (parse-board-row (read-line))) five)))))

(define read-boards
  (lambda ()
    (let ([board (read-board)])
      (if (not (null? board)) (cons board (read-boards)) '()))))

(define play
  (lambda (step all-numbers boards)
    (letrec ([numbers (list-tail all-numbers step)]
             [winning-boards (filter (lambda (board) (check-board board numbers)) boards)])
      (if (null? winning-boards)
        (play (- step 1) all-numbers boards)
        (score-board (car winning-boards) numbers)))))

(define play-last
  (lambda (step all-numbers boards)
    (letrec ([numbers (list-tail all-numbers step)]
             [winning-boards (filter (lambda (board) (check-board board numbers)) boards)]
             [other-boards (filter (lambda (board) (not (check-board board numbers))) boards)])
      (if (or (null? winning-boards) (not (null? other-boards)))
        (play-last (- step 1) all-numbers other-boards)
        (score-board (car winning-boards) numbers)))))

(letrec ([numbers (reverse (parse-numbers (read-line)))]
         [boards (read-boards)]
         [first-step (- (length numbers) 1)]
         [part (vector-ref (current-command-line-arguments) 0)])
  (if (equal? part "1")
    (writeln (play first-step numbers boards))
    (writeln (play-last first-step numbers boards))))

; vim: ts=2 sw=2 et
