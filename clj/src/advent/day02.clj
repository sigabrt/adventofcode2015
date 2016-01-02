(ns advent.day02
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

(defn wrapping-paper-area
  "Calculates the minimum amount of wrapping paper required for the given box."
  [[l w h]]
  (let [s1 (* l w)
        s2 (* l h)
        s3 (* w h)]
    (+ (* s1 2) (* s2 2) (* s3 2) (min s1 s2 s3))))

(defn ribbon-length
  "Calculates the minimum amount of ribbon required to decorate the given box."
  [[l w h]]
  (let [p1 (+ (* l 2) (* w 2))
        p2 (+ (* l 2) (* h 2))
        p3 (+ (* w 2) (* h 2))]
    (+ (min p1 p2 p3) (* l w h))))

(defn part1
  []
  (reduce +
    (map
      (fn [line]
        (let [dims (map read-string (str/split line #"x"))]
          (wrapping-paper-area dims)))
      (line-seq (io/reader (io/resource "day02.txt"))))))

(defn part2
  []
  (reduce +
    (map
      (fn [line]
        (let [dims (map read-string (str/split line #"x"))]
          (ribbon-length dims)))
      (line-seq (io/reader (io/resource "day02.txt"))))))
