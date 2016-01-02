(ns advent.day02-test
  (:require [clojure.test :refer :all]
            [advent.day02 :refer :all]))

(deftest wrapping-paper-test
  (is (= 0  (wrapping-paper-area [0 0 0])))
  (is (= 0  (wrapping-paper-area [1 0 0])))
  (is (= 58 (wrapping-paper-area [2 3 4])))
  (is (= 43 (wrapping-paper-area [1 1 10]))))

(deftest ribbon-length-test
  (is (= 0  (ribbon-length [0 0 0])))
  (is (= 34 (ribbon-length [2 3 4])))
  (is (= 14 (ribbon-length [1 1 10]))))
