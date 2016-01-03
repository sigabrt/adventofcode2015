(ns advent.day04
  (:require [clojure.java.io :as io]
            [digest]))

(defn find-hash-with-prefix
  [key prefix]
  (first
    (filter
      #(.startsWith (digest/md5 (str key %1)) prefix)
      (range))))

(defn part1
  []
  (find-hash-with-prefix
    (slurp (io/resource "day04.txt"))
    "00000"))

(defn part2
  []
  (find-hash-with-prefix
    (slurp (io/resource "day04.txt"))
    "000000"))
