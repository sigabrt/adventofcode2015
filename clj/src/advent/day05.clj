(ns advent.day05
  (:require [clojure.java.io :as io]))

(def vowel? (set "aeiou"))
(def bad-words #{"ab" "cd" "pq" "xy"})

(defn has-vowels?
  [word num-vowels]
  (>= (count (filter vowel? word)) num-vowels))

(defn repeating-letters?
  [word repeat]
  (some
    #(apply = %)
    (partition repeat 1 word)))

(defn clean?
  [word]
  (= (count (filter #(.contains word %1) bad-words)) 0))

(defn nice?
  [word]
  (and (has-vowels? word 3)
       (repeating-letters? word 2)
       (clean? word)))

(defn part1
  []
  (count
    (filter
      nice?
      (line-seq (io/reader (io/resource "day05.txt"))))))
