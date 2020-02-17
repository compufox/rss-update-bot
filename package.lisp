;;;; package.lisp

(defpackage #:qlupdate-bot
  (:use #:cl #:with-user-abort #:glacier)
  (:import-from :unix-opts
		:define-opts
		:get-opts)
  (:import-from :cl-feedparser
		:parse-feed
		:feed-ref))
(in-package :qlupdate-bot)

(defvar *config-file* nil
  "config file we should load")

;; i would like to save this to the config, but that
;;  would require the newest version of SIMPLE-CONFIG which isnt
;;  in quicklisp yet
(defvar *newest-post* nil
  "saves the last time we checked the blog for updates")
(defvar *ql-url* "http://blog.quicklisp.org/feeds/posts/default"
  "quicklisp blog rss url")

(define-opts
  (:name :config
   :short #\c
   :long "config"
   :arg-parser #'identity
   :meta-var "FILE"))
