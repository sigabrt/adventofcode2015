(defproject advent "0.1.0-SNAPSHOT"
  :description "Advent of Code 2015 in Clojure"
  :url "https://github.com/sigabrt/adventofcode2015"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [digest "1.4.4"]]
  
  :profiles {:dev {:source-paths ["dev"]
                   :dependencies [[org.clojure/tools.namespace "0.2.11"]]}})
