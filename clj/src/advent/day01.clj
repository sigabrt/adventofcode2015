(ns advent.day01
  (:require [clojure.java.io :as io]))

(defn part1
  []
  (reduce
    (fn [total c]
      (if (= c \()
        (+ total 1)
        (if (= c \))
          (- total 1)
          total)))
    0
    (slurp (io/resource "day01.txt"))))

(defn part2
  []
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
        (map-indexed vector (slurp (io/resource "day01.txt")))))))
