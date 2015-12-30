(require 'leiningen.exec)
(leiningen.exec/deps '[[org.clojure/core.match "0.3.0-alpha4"]])

(require '[clojure.core.match :refer [match]])

(defn move
  "Calculates a new [x, y] position based on a move character (^>v<)."
  [[x y] c]
  (match [c]
    [\<] [(- x 1) y]
    [\>] [(+ x 1) y]
    [\v] [x (- y 1)]
    [\^] [x (+ y 1)]
    [_]  [x y]))

(defn calc-visited-houses
  ([moves] (calc-visited-houses moves #{}))
  ([moves visited-houses]
   (loop [pos [0 0]
          next moves
          visited visited-houses]
     (if (= (count next) 0)
       visited
       (recur (move pos (first next))
              (rest next)
              (conj visited pos))))))

(let [moves (slurp *in*)]
  (println
    (count
      (calc-visited-houses
        (take-nth 2 moves)
        (calc-visited-houses
          (take-nth 2 (rest moves)))))))
