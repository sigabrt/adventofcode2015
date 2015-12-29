(if (>= (count *command-line-args*) 2)
  (println
    (reduce
      (fn [total c]
        (if (= c \()
          (+ total 1)
          (if (= c \))
            (- total 1)
            total)))
      0
      (second *command-line-args*))))
