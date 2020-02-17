;;;; package.lisp

(defpackage #:rss-update-bot
  (:use #:cl #:with-user-abort #:glacier)
  (:import-from :unix-opts
		:define-opts
		:get-opts)
  (:import-from :cl-feedparser
		:parse-feed
		:feed-ref))
(in-package :rss-update-bot)

(defvar *config-file* nil
  "config file we should load")

;; i would like to save this to the config, but that
;;  would require the newest version of SIMPLE-CONFIG which isnt
;;  in quicklisp yet
(defvar *newest-post* nil
  "timestamp for the most recent published rss entry")
(defvar *url* nil
  "rss url")

(define-opts
  (:name :help
   :short #\h
   :long "help")
  (:name :config
   :short #\c
   :long "config"
   :arg-parser #'identity
   :meta-var "FILE")
  (:name :url
   :short #\u
   :long "url"
   :arg-parser #'identity
   :meta-var "URL"))
