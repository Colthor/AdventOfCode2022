(ns day20part2
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
  (map-indexed #(cons (Integer. %2) [%1])
               (clojure.string/split-lines (slurp filename))))

(defn mix [input]
  (println "mix!")
  ;(println input)
  (let [length (- (count input) 1)]
    (loop [xs input
           i  0]
      (let [item (first (first (filter #(= (second %) i) xs)))
            n (.indexOf xs [item i])]
        (if (> i length)
          xs
          (let [newpos (mod (+ n item) length)]
            ;(println [i item n newpos])
            (recur (insert-at [item i] newpos (drop-nth n xs)) (+ i 1))))))))


(defn part1 []
  (let [mixed (map first (mix (read-file path)))
        length (count mixed)
        zero   (.indexOf mixed 0)]
    ;(println mixed)
    (apply + (map #(nth  mixed (mod (+ zero %) length)) [1000 2000 3000])))) ; tell me you understand this without the other version up there.

(def decryption-key 811589153)

(defn part2 []
  (let [input (map #(cons (* (first %) decryption-key) [(second %)]) (read-file path))
        mixed (map first (nth (iterate mix input) 10))
        length (count mixed)
        zero   (.indexOf mixed 0)]
    (apply + (map #(nth  mixed (mod (+ zero %) length)) [1000 2000 3000]))))

(println "working!")
;(println (part1))
(println (part2))