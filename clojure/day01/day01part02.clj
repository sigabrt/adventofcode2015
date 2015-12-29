(if (>= (count *command-line-args*) 2)
  (println
    (+ 1
      (first
        (reduce
          (fn [[index floor] next]
            (if (= floor -1)
              [index floor]
              (let [i (first next)
                    c (second next)]
                (if (= c \()
                  [i (+ floor 1)]
                  (if (= c \))
                    [i (- floor 1)]
                    [index floor])))))
          [0 0]
          (map-indexed vector (second *command-line-args*)))))))
