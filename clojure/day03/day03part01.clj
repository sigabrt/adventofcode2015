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
  [moves]
  (loop [pos [0 0]
         next moves
         visited #{}]
    (if (= (count next) 0)
      (count visited)
      (recur (move pos (first next))
             (rest next)
             (conj visited pos)))))

(println (calc-visited-houses (slurp *in*)))
