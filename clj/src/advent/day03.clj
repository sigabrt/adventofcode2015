(ns advent.day03
  (:require [clojure.java.io :as io]))

(defn move
  "Returns the [x y] offset of the specified move character (<, >, ^, or v)"
  [c]
  (case c
    \^ [ 0  1]
    \v [ 0 -1]
    \> [ 1  0]
    \< [-1  0]
       [ 0  0]))

(defn visited-houses
  [moves]
  (set
    (reductions
      #(map + %1 %2)
      [0 0]
      (map move moves))))

(defn part1
  []
  (count (visited-houses (slurp (io/resource "day03.txt")))))

(defn part2
  []
  (let [moves       (slurp (io/resource "day03.txt"))
        santa-moves (take-nth 2 moves)
        robo-moves  (take-nth 2 (rest moves))]
    (count
      (clojure.set/union
        (visited-houses santa-moves)
        (visited-houses robo-moves)))))
