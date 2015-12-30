(require '[clojure.string :as str])

(defn wrapping-paper-area
  "Calculates the minimum amount of wrapping paper required for the given box."
  [[l w h]]
  (let [s1 (* l w)
        s2 (* l h)
        s3 (* w h)]
    (+ (* s1 2) (* s2 2) (* s3 2) (min s1 s2 s3))))

(println
  (reduce +
    (map
      (fn [line]
        (let [dims (map read-string (str/split line #"x"))]
          (wrapping-paper-area dims)))
      (line-seq (java.io.BufferedReader. *in*)))))
