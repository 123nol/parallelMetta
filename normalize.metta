(=(normalize $matrix) (collapse (handleRow (superpose $matrix))))




(=(handleRow $row) (let* 
(($mag-ish (foldl-atom $row 0 $acc $x (+ $acc (pow-math $x 2))))
($mag (sqrt-math $mag-ish))
)
(collapse (handleEntry (superpose $row) $mag))

))
(=(handleEntry $entry $mag) (/ $entry $mag))
;============================

(=(normalize-with-proof $matrix) (let* (($norm-mat (collapse (handleRow (superpose $matrix)))) ($norm-mag  (mag-mat $norm-mat) )) (matric $norm-mat mag $norm-mag)  )   )
(=(mag-mat $norm-mat) (collapse (calc-mag (superpose $norm-mat))))

(=(calc-mag $row) (let* (($mag-ish (foldl-atom $row 0 $acc $x (+ $acc (pow-math $x 2))))
($mag (sqrt-math $mag-ish))
) ($mag)))

l!(normalize ((1 2 3) (5 6 7 ) (9 10 11) ))
!(normalize-with-proof ((1 2 3) (5 6 7 ) (9 10 11)) )