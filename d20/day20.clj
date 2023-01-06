(ns day20
  (:gen-class))
(require '[clojure.string])

;(def path "/home/michael/AdventOfCode/d20/day20test.txt")
(def path "/home/michael/AdventOfCode/d20/day20.txt")


;inspired by insert-at, a drop-nth that doesn't overflow the stack
;unlike the one I stole from, guess where. Yup.
(defn drop-nth ([n coll]
                (drop-nth n coll []))
  ([n coll accum]
   (if (empty? coll)
     accum
     (if (== 0 n)
       (concat accum (rest coll))
       (recur (- n 1) (rest coll) (conj accum (first coll)))))))


;(defn insert-at [item n coll]
;  (let [[before after] (split-at n coll)]
;    (concat before [item] after)))

;this looks longwinded but the short version overflows the stack
(defn insert-at ([item n coll]
                 (insert-at item n coll []))
  ([item n coll accum]
   (if (empty? coll)
     (conj accum item)
     (if (== 0 n)
       (concat accum (cons item coll))
       (recur item (- n 1) (rest coll) (conj accum (first coll)))))))



(defn read-file [filename]
  (map #(cons (Integer. %) [0])
       (clojure.string/split-lines (slurp filename))))

(defn mix [input]
  (let [length (- (count input) 1)]
    (loop [xs input]
      (let [item (first (first (filter #(= (second %) 0) xs)))
            n (.indexOf xs [item 0])]
        (if (== n -1)
          (map first xs)
          (let [newpos (mod (+ n item) length)]
            ;(println [item n newpos])
            (recur (insert-at [item 1] newpos (drop-nth n xs)))))))))

(defn part1debug []
  (let [mixed (mix (read-file path))
        length (count mixed)
        zero   (.indexOf mixed 0)
        p1     (mod (+ zero 1000) length) ; this should really be some kind of map over [1000 2000 3000] shouldn't it?
        p2     (mod (+ zero 2000) length)
        p3     (mod (+ zero 3000) length)
        v1     (nth mixed p1)
        v2     (nth mixed p2)
        v3     (nth mixed p3)]
    (println [v1 v2 v3 "=" (+ v1 v2 v3)])
    (+ v1 v2 v3)))

(defn part1 []
  (let [mixed (mix (read-file path))
        length (count mixed)
        zero   (.indexOf mixed 0)]
    (apply + (map #(nth mixed %) (map #(mod (+ zero %) length) [1000 2000 3000])))))

(println "working!")
(println (part1))