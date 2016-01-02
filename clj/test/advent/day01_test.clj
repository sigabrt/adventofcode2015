(ns advent.day01-test
  (:require [clojure.test :refer :all]
            [advent.day01 :refer :all]))

(deftest basic-moves
  (testing "Move values"
    (is (= 1  (move-offset \()))
    (is (= -1 (move-offset \)))))
  (testing "Basic move strings"
    (is (= 1  (calc-move-result "(")))
    (is (= -1 (calc-move-result ")")))
    (is (= 0  (calc-move-result "()"))))
  (testing "More complex move strings"
    (is (= 0 (calc-move-result "(())")))
    (is (= 0 (calc-move-result "()()")))
    (is (= 1 (calc-move-result "((())")))
    (is (= 1 (calc-move-result "(()()")))))
