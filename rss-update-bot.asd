;;;; rss-update-bot.asd

(asdf:defsystem #:rss-update-bot
  :description "mastodon bot that posts when an rss feed updates"
  :author "ava fox"
  :license  "NPLv1+"
  :version "0.0.1"
  :serial t
  :depends-on (#:glacier #:cl-feedparser
	       #:with-user-abort #:dexador
	       #:unix-opts)
  :components ((:file "package")
               (:file "rss-update-bot"))
  :build-operation "program-op"
  :build-pathname #-Win32 "bin/rss-bot"
                  #+Win32 "bin/rss-bot.exe"
  :entry-point "rss-update-bot::main")

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression t))


