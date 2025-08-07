
; Fast matrix exponentiation by squaring
(= (matpow $mat $k)
   (if (== $k 1)
       $mat
       (if (== ((py-atom math.fmod) $k 2) 0.0)
           (let* (( $half (matpow $mat (/ $k 2)) ))
               (matmul-raw $half $half)
           )
           (let* (( $half (matpow $mat (/ (- $k 1) 2)) ))
               (matmul-raw $mat (matmul-raw $half $half))
           )
       )
   )
)

; Raw matrix multiplication: returns the product matrix (not diagonal sum)
(= (matmul-raw $mat1 $mat2)
   (let* (
       ($mag (size-atom $mat1))
       ($transp (transpose $mat2 $mag 0 ()))
       ($rows (reverse (collapse (handle-row (superpose $mat1) $transp)) ()))
   ) $rows)
)

; Fast diagonal sum for A^k
(= (matmul-fast $mat $k)
   (let* (( $matk (matpow $mat $k) ))
       (let* (( $msum (get-diag-sum $matk) ) ($lsum (get-diag-sum-sub $matk) ))
           (+ $msum $lsum)
       )
   )
)




(=(generate-helper $start $end $step $acc)
(if (>= $start $end) $acc (let $new (union-atom $acc ($start)) (generate-helper (+ $start $step) $end $step $new)))
)
(=(generate $start $end $step ) (generate-helper $start $end $step ()))
(=(generate $end) (generate 0 $end 1))

;=======================================

(= (zip-lists $lst1 $lst2 $acc)
   (if (or (== $lst1 ()) (== $lst2 ()))
       $acc
       (let* (
           ($head1 (car-atom $lst1))
           ($head2 (car-atom $lst2))
           ($tail1 (cdr-atom $lst1))
           ($tail2 (cdr-atom $lst2))
           ($pair ($head1 $head2))
           ($new (union-atom $acc ($pair)))
           
         )
         (zip-lists $tail1 $tail2 $new )
       )
   )
)

;==========================


(=(matmul $matric $k $transposed) (if (== (- $k 1) 0) (let*  (($msum (get-diag-sum $matric)) ($lsum (get-diag-sum-sub $matric))) (+ $msum $lsum) ) (let* (($mag (size-atom $matric)) ($transp (if (== $transposed ()) (transpose $matric $mag 0 ()) $transposed)) ($new_matric   (handle-matric $matric $mag $transp))) (matmul $new_matric (- $k 1) $transp))))

; (=(matmul $matric $k $transposed) (if (== (- $k 1) 0) (get-diag-sum $matric) (let* (($mag (size-atom $matric)) ($transp (if (== $transposed ()) (transpose $matric $mag 0 ()) $transposed)) ($new_matric   (handle-matric $matric $mag $transp))) (matmul $new_matric (- $k 1) $transp))))


(= (handle-matric $matric $mag $transposed) (let* (($rows (reverse (collapse (handle-row (superpose $matric) $transposed)) ()))) $rows))


(=(handle-row $sup-row $transpose) (reverse (collapse (make-entry $sup-row (superpose $transpose))) ()))

(=(make-entry $row $sup-col) (let* (($zipped (zip-lists $row $sup-col ())) ($lst-to-add (collapse (mult (superpose $zipped)))) ($ent (foldl-atom $lst-to-add 0 $acc $x (+ $acc $x)))) $ent))

(=(mult ($x1 $x2)) (* $x1 $x2))

; we need to superpose each row and mutiply each row is then antoher function gets that paritcular row and also the superposed matrix of the trasnspose , then zip and multiply each entery, then collapsing it would give the reversed ai1 ai2 ai3, so we prolly would need to reverse it

 (=(transpose $matric $mag $cur $acc) (if (< $cur $mag) (let* ( ($col (collapse (get-col (superpose $matric) $cur))) ($reversed-col (reverse $col ()))) (transpose $matric $mag (+ 1 $cur) (union-atom $acc ($reversed-col)))) $acc))


(=(get-col $row $index) (index-atom $row $index))
(=(reverse $row $acc) (if (== $row ()) $acc (let $el (car-atom $row) (reverse (cdr-atom $row) (cons-atom $el $acc)) )) )

(=(get-diag-sum $matric) (let* (($mag (size-atom $matric)) ($ind (generate $mag)) ($zipped (zip-lists $matric $ind ())) ($diag-entry (collapse (get-diag-el (superpose $zipped) ))) ($dsum (foldl-atom $diag-entry 0 $acc $x (+ $acc $x))) ) $dsum))


(=(get-diag-sum-sub $matric) (let* (($mag (size-atom $matric)) ($ind (generate 1 (+ 1 $mag) 1)) ($zipped (zip-lists $matric $ind ())) ($diag-entry (collapse (get-diag-el-sub (superpose $zipped) $mag ))) ($dsum (foldl-atom $diag-entry 0 $acc $x (+ $acc $x))) ) $dsum))

(= (get-diag-el ($row $ind)) (index-atom $row $ind))

(= (get-diag-el-sub ($row $ind) $mag) (let $rin (- $mag $ind) (index-atom $row $rin)))

;!(get-diag-sum-sub ((1 2 3) (4 5 6) (7 8 9)))

;!(transpose ((1 2 3) (4 5 6) (7 8 9)) 3 0 ())

;!(reverse (collapse(get-col (superpose ((1 2 3) (4 5 6) (7 8 9))) 0)) ())

;!(matmul ((1 2 3) (4 5 6) (7 8 9)) 1 () )

!(matmul-fast ((1 2 3) (4 5 6) (7 8 9)) 4)





