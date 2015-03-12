---
layout: post
title: "Создание боксов для Vagrant"
tags: ["chef", "veewee", "vagrant", "ruby"]
---

Ох, и замотал меня этот ваш Vagrant. Скачаешь один бокс — Ruby старый, скачаешь другой бокс — chef не заводится.

Мне порядком поднадоело, что с chef'ом у меня ничего не растёт, поэтому нашёл хороший туториал, для деревьев вроде меня, на тему «[Как собрать свой Vagrant box и не обосраться](http://nepalonrails.com/post/13197838780/build-your-own-vagrant-box-ready-to-use-with-chef-solo)».

О результатах трепыханий раскажу позже.

*UPD*: всё делаем по вышеназванному туториалу. Получаем работающую VM. Чтобы получить вожделенный \*.box делаем

<pre><code class="bash">
bundle exec vagrant basebox export 'box-name'
</code></pre>

Опосля, в директории, где наш Vagrantfile лежит делаем:

<pre><code class="bash">
vagrant box add box-name /path/to/box-name.box
vagrant up
</code></pre>

Теперь можно улыбаться.

*UPD2*: если что-то забыли сделать или накосячили в настройке коробки после её экспорта:

<pre><code class="bash">
cd /path/to/veewee
bundle exec vagrant basebox up 'box-name'
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -p 7222 -l vagrant 127.0.0.1
</code></pre>

и опять

<pre><code class="bash">
bundle exec vagrant basebox export 'box-name'
</code></pre>
