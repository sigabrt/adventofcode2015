(require '[clojure.string :as str])

(defn wribbon-length
  "Calculates the minimum amount of ribbon required to decorate the given box."
  [[l w h]]
  (let [p1 (+ (* l 2) (* w 2))
        p2 (+ (* l 2) (* h 2))
        p3 (+ (* w 2) (* h 2))]
    (+ (min p1 p2 p3) (* l w h))))

(println
  (reduce +
    (map
      (fn [line]
        (let [dims (map read-string (str/split line #"x"))]
          (wribbon-length dims)))
      (line-seq (java.io.BufferedReader. *in*)))))
