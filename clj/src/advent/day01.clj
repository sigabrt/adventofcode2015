(ns advent.day01
  (:require [clojure.java.io :as io]))

(defn move-offset
  [c]
  (case c
        \( 1
        \) -1
        0))

(defn calc-move-result
  [moves]
  (reduce + (map move-offset moves)))

(defn part1
  []
  (calc-move-result (slurp (io/resource "day01.txt"))))

(defn part2
  []
  (+ 1
    (.indexOf
      (reductions + (map move-offset (slurp (io/resource "day01.txt"))))
      -1)))
