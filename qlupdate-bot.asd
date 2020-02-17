;;;; qlupdate-bot.asd

(asdf:defsystem #:qlupdate-bot
  :description "mastodon bot that posts when quicklisp updates"
  :author "ava fox"
  :license  "NPLv1+"
  :version "0.0.1"
  :serial t
  :depends-on (#:glacier #:cl-feedparser
	       #:with-user-abort #:dexador
	       #:unix-opts)
  :components ((:file "package")
               (:file "qlupdate-bot"))
  :build-operation "program-op"
  :build-pathname "bin/qlupdate-bot"
  :entry-point "qlupdate-bot::main")

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))


