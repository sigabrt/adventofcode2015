(ns advent.day04
  (:require [clojure.java.io :as io]
            [digest]))

(defn part1
  []
  (let [key (slurp (io/resource "day04.txt"))]
    (first
      (filter
        #(.startsWith (digest/md5 (str key %1)) "00000")
        (range)))))

(defn part2
  []
  (let [key (slurp (io/resource "day04.txt"))]
    (first
      (filter
        #(.startsWith (digest/md5 (str key %1)) "000000")
        (range)))))
