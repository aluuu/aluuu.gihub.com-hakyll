---
layout: post
title: Расстояние Левенштейна
tags: ["clojure", "math", "fp"]
---

Поскольку скоро придётся сравнивать много всяких последовательностей, запилил я [расстояние Левенштейна](http://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D1%81%D1%81%D1%82%D0%BE%D1%8F%D0%BD%D0%B8%D0%B5_%D0%9B%D0%B5%D0%B2%D0%B5%D0%BD%D1%88%D1%82%D0%B5%D0%B9%D0%BD%D0%B0) на Clojure (эксперимента ради).

Возьмём реализацию в лоб:

<pre><code class="clojure">(defn levenshtein-distance
  [seq1 seq2]
  (cond
   (empty? seq1) (count seq2)
   (empty? seq2) (count seq1)
   :else (min
          (+ (if (= (first seq1) (first seq2)) 0 1)
             (#'levenshtein-distance (rest seq1) (rest seq2)))
          (inc (#'levenshtein-distance (rest seq1) seq2))
          (inc (#'levenshtein-distance seq1 (rest seq2))))))
</code></pre>


Всё очень плохо:

<pre><code class="clojure">(time (levenshtein-distance (shuffle (range 10))
                            (shuffle (range 10))))
"Elapsed time: 2566.345769 msecs"
9
</code></pre>

Делаем хорошо следующим образом. В `clojure.core` есть отличная функция [`memoize`](http://clojuredocs.org/clojure_core/clojure.core/memoize), которая возвращает [мемоизированную](http://en.wikipedia.org/wiki/Memoization) версию заданной функции.

Замутим мемоизацию для функции levenstein-distance:


<pre><code class="clojure">(defn memo-levenshtein-distance
  [seq1 seq2]
  (cond
   (empty? seq1) (count seq2)
   (empty? seq2) (count seq1)
   :else (min
          (+ (if (= (first seq1) (first seq2)) 0 1)
             (#'memo-levenshtein-distance (rest seq1)
                                          (rest seq2)))
          (inc (#'memo-levenshtein-distance (rest seq1)
                                            seq2))
          (inc (#'memo-levenshtein-distance seq1
                                            (rest seq2))))))

(def memo-levenshtein-distance (memoize memo-levenshtein-distance))
</code></pre>

Проверим насколько стало хорошо:

<pre><code class="clojure">(let [seq1 (shuffle (range 10))
      seq2 (shuffle (range 10))]
  (map #(time (% seq1 seq2))
       [levenshtein-distance
        memo-levenshtein-distance]))
 ("Elapsed time: 2560.824951 msecs"
 "Elapsed time: 1.265487 msecs"
 9
 9)
</code></pre>

Радуемся.
