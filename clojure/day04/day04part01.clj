(require 'leiningen.exec)
(leiningen.exec/deps '[[digest "1.4.4"]])

(require 'digest)

(println
  (let [key (second *command-line-args*)]
    (loop [val 1]
      (let [hash (digest/md5 (str key val))]
        (if (.startsWith hash "00000")
          val
          (recur (inc val)))))))
