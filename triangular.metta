(=(generate-helper $start $end $step $acc)
(if (>= $start $end) $acc (let $new (union-atom $acc ($start)) (generate-helper (+ $start $step) $end $step $new)))
)
(=(generate $start $end $step ) (generate-helper $start $end $step ()))
(=(generate $end) (generate 0 $end 1))
;===================================

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

(=(repeat $x $n $acc)
(if (> $n 0) (let $new (cons-atom $x  $acc) (repeat $x (- $n 1) $new) ) $acc)


)
;================================


(= (triangle-left $sq-matrix) (let* (
  ($mag (size-atom $sq-matrix))
  ($indicies (generate 1 (+ $mag 1) 1))
  ($zipped (zip-lists $sq-matrix $indicies ()))
  
   ($pro-rows (reverse (collapse (process-row-left (superpose $zipped) 1 $mag () )) ()))

  )
  $pro-rows
  ))

(= (triangle-right $sq-matrix) (let* (
  ($mag (size-atom $sq-matrix))
  ($indicies (generate 1 (+ $mag 1) 1))
  ($zipped (zip-lists $sq-matrix $indicies ()))
 
   ($pro-rows (reverse (collapse (process-row-right (superpose $zipped) $mag)) ()))
  )
  $pro-rows
  ))

(=(reverse $row $acc) (if (== $row ()) $acc (let $el (car-atom $row) (reverse (cdr-atom $row) (cons-atom $el $acc)) )) )


(= (process-row-left ($row $index) $cur $size $acc)

(if (<= $cur $index ) (let* (($el (car-atom $row)) ($tail (cdr-atom $row))) (process-row-left ($tail $index) (+ $cur 1) $size  (union-atom $acc ($el))))  (let* (($zeros (repeat 0 (- $size $index) ()))) (union-atom $acc $zeros)))

)

(= (process-row-right ($row $index) $size)

 (let* (($start (- $size $index)) ($tail (get-row-above $row $size $start ())) ($zeros (repeat 0 (- $size $index) ())) ($new-row (union-atom $zeros $tail))) $new-row )  )
;(=(get-row-above $row $index $len $start $acc) (if (< $cur (- $len $index)) (let* ( ($el (index-atom $row $index))) (get-row-above ))))

(=(get-row-above $row $len $start $acc) (if (>= $start $len) $acc (let* ( ($el (index-atom $row $start))) (get-row-above $row $len (+ $start 1) (union-atom $acc ($el))  ))))



!(triangle-left ((1 2 3 4 5) (5 6 7 8 9) (9 10 11 12 13) (15 16 17 18 19) (21 22 23 24 25 )))
!(triangle-right ((1 2 3 4 5) (5 6 7 8 9) (9 10 11 12 13) (15 16 17 18 19) (21 22 23 24 25 )))