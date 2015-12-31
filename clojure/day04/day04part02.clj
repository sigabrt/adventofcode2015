(require 'leiningen.exec)
(leiningen.exec/deps '[[digest "1.4.4"]])

(require 'digest)

(defn md5-with-postfix
  [key val]
  (digest/md5 (str key val)))

(println
  (let [key (second *command-line-args*)]
    (first
      (filter
        #(.startsWith (md5-with-postfix key %1) "000000")
        (range)))))
