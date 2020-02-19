;;;; rss-update-bot.asd

(asdf:defsystem #:rss-update-bot
  :description "mastodon bot that posts when an rss feed updates"
  :author "ava fox"
  :license  "NPLv1+"
  :version "0.2"
  :serial t
  :depends-on (#:glacier #:cl-feedparser
	       #:with-user-abort #:dexador
	       #:unix-opts)
  :components ((:file "package")
               (:file "rss-update-bot"))
  :build-operation "program-op"
  :build-pathname "bin/rss-bot"
  :entry-point "rss-update-bot::main")

#+(and sb-core-compression (not Win32))
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))


