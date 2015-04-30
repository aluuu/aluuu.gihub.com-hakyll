---
layout: post
title: "Clojure, JTS, Leiningen и korma.postgis"
tags: ["clojure", "lein", "jts"]
---

Блин, всё-таки классная штука эта ваша Clojure. Долго убивался, искал как поставить JTS. В итоге что-то привело меня к [ClojureSphere](http://www.clojuresphere.com/). В итоге скоприровал в :dependencies своего проекта следующее и всё завелось с lein deps:

<pre><code class="clojure">[com.vividsolutions/jts "1.12"]
[org.postgis/postgis-jdbc "1.3.3"]
</code></pre>

Ляпота.
