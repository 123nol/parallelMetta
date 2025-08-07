
; This function normalizes each row of a matrix by dividing each element by the square root of the sum of squares of the elements in that row.
(= (L2 $matrix) 
    (collapse (let*
        (
            ($rows (superpose $matrix))
            ($denominators (sqrt-math (foldl-atom $rows 0 $acc $x (+ (pow-math $x 2) $acc))))
            ($newrows (map-atom $rows $ele (/ (* $ele 1.0) $denominators)))
        )
        $newrows
    ))
)
; ((1 2 3) (2 3 4)) -> 1/x, 2/x, x = 


; !(L2 ((1 2 3 9 10) (2 3 4 -2 -2) (3 4 5 12 10) (3 4 5 12 10) (3 4 5 12 10)))

; This function enumerates the elements of a list, returning a list of pairs where each pair consists of an index and the corresponding element.
(= (enumerate_helper_internal $acc $ele) 
    (let ($x ($y)) (decons-atom $acc))
)
(= (enumerate_helper_internal $acc $ele) 
    (let*
        (
            (($x ($y)) (decons-atom $acc))
            ($newAcc (+ $x 1))
            ($newele (union-atom $y (($newAcc $ele))))

        ) 
        ($newAcc $newele)
    )
)

(= (enumerate $list) 
    (let ($r1 $r2) (foldl-atom $list (-1 ()) $acc $ele (enumerate_helper_internal $acc $ele)) $r2)
)

; !(enumerate (1 21 10 4 5)) 

(= (triangle_helper_2 $rowIndex ($eleIndex $ele) $type) 
    (if (== $type 0)
        (if (>= $eleIndex $rowIndex) $ele 0)
        (if (<= $eleIndex $rowIndex) $ele 0)
    )
)

(= (triangle_helper ($rowIndex $row) $type)
    (let $rrooww (enumerate $row) (map-atom $rrooww $e (triangle_helper_2 $rowIndex $e $type)))
)
(= (upper_triangle $matrix) 
    (let $x (enumerate $matrix) (map-atom $x $pairs (triangle_helper $pairs 0)))
)

; !(upper_triangle ((1 2 3 9 10) (2 3 4 -2 -2) (3 4 5 12 10) (3 4 5 12 10) (3 4 5 12 10)))

(= (lower_triangle $matrix)
    (let $x (enumerate $matrix) (map-atom $x $pairs (triangle_helper $pairs 1)))
)

; !(lower_triangle ((1 2 3 9 10) (2 3 4 -2 -2) (3 4 5 12 10) (3 4 5 12 10) (3 4 5 12 10)))

; (= (matrix_power $matrix $power) 
;     (if (== $power 0)
;         (identity-matrix (length $matrix))
;         (if (== $power 1)
;             $matrix
;             (let ($halfPower) (floor (/ $power 2)))
;                 (let ($halfMatrix) (matrix_power $matrix $halfPower))
;                     (if (even? $power)
;                         (multiply-matrix $halfMatrix $halfMatrix)
;                         (multiply-matrix $matrix (multiply-matrix $halfMatrix $halfMatrix))
;                     )
;         )
;     )
; )

; This function transposes a matrix by swapping rows and columns. notice -> it only works for sqaure matrices
(= (transpose_helper $matrix $index $result) 
    (if (> (+ 1 $index) (size-atom $matrix))
        $result
        (let* 
            (
                ($col (map-atom $matrix $row (index-atom $row $index)))
                ($newResult (union-atom $result ($col)))
            )
            (transpose_helper $matrix (+ 1 $index) $newResult)
        )
    )
)

(= (transpose $matrix)
    (transpose_helper $matrix 0 ())
)

; !(transpose ((1 2 3) (4 5 6) (7 8 9)))

(= (zipWith $fn $a $b) (zipWith $fn $a $b ()))
(= (zipWith $fn $a $b $acc)
    (function 
        (chain (eval (if-decons-expr $a $ah $at 
            (chain (eval (if-decons-expr $b $bh $bt 
                (chain (eval ($fn $ah $bh)) $cur
                (chain (eval (union-atom $acc ($cur))) $nacc
                (chain (eval (zipWith $fn $at $bt $nacc)) $r $r))) ())) $r1 $r1) $acc)) $f 
                (return $f))))



(= (multiply $a $b) (* $a $b))

; !(zipWith multiply (1 2 3 4 5) (2 3 4 5 6))

(= (dot_product $vector1 $vector2) 
    (let $productVector (zipWith multiply $vector1 $vector2) (foldl-atom $productVector 0 $acc $x (+ $acc $x)))
)

(= (multiply_matrix $matrix1 $matrix2) 
    (if (not (== (let $x (index-atom $matrix1 0) (size-atom $x)) (size-atom $matrix2)))
        (() (println! "Can not multiply incompatible matrices"))
        (let $matrix2T (transpose $matrix2)
            (transpose (map-atom $matrix1 $row1 (map-atom $matrix2T $row2 (dot_product $row1 $row2))))
        )
    )
)

; !(multiply_matrix ((1 2 10) (3 4 10) (2 3 4)) ((4 6 9) (8 9 -10) (1 2 15)))

(= (matrix_power_helper $matrix $power $acc) 
    (if (== $power 1)
        $acc
        (let $newAcc (multiply_matrix $acc $matrix) (matrix_power_helper $matrix (- $power 1) $newAcc))
    )
)

(= (matrix_power $matrix $power) (matrix_power_helper $matrix $power $matrix))

; !(matrix_power ((1 2) (3 4)) 3)

(= (trace_helper_internal ($rowIndex $row)) (index-atom $row $rowIndex))
(= (trace_matrix $matrix) 
    (let $enumMatrix (enumerate $matrix) (foldl-atom $enumMatrix 0 $acc $pairs (+ (trace_helper_internal $pairs) $acc)))
)
(= (trace_matrix $matrix $power) 
    (let $enumMatrix (enumerate (matrix_power $matrix $power)) (foldl-atom $enumMatrix 0 $acc $pairs (+ (trace_helper_internal $pairs) $acc)))
)
; !(trace_matrix ((1 2) (3 4)))
; !(trace_matrix ((1 2 3 9 10) (2 3 4 -2 -2) (3 4 5 12 10) (3 4 5 12 10) (3 4 5 12 10)) 5)