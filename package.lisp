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
;; update: it IS in quicklisp
(defvar *newest-post* (make-hash-table :size 4 :test 'equal)
  "timestamp for the most recent published rss entry")
(defvar *urls* nil
  "rss urls")

(define-opts
  (:name :help
   :description "prints this help"
   :short #\h
   :long "help")
  (:name :version
   :description "print version info"
   :long "version")
  (:name :config
   :description "specify a config file to load"
   :short #\c
   :long "config"
   :arg-parser #'identity
   :meta-var "FILE"))
