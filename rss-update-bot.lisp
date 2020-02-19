;;;; rss-update-bot.lisp

(in-package #:rss-update-bot)

(defun check-feed ()
  (let ((feed (parse-feed (dex:get *url*) :max-entries 10)))
    (unless *newest-post*
      (setf *newest-post*
	    (feed-ref (first (feed-ref feed :entries)) :published-parsed)))
    
    (dolist (entry (reverse (feed-ref feed :entries)))
      (when (> (feed-ref entry :published-parsed) *newest-post*)
	(post (format nil "~a~%~%~a"
		      (feed-ref entry :title)
		      (feed-ref entry :link))
	      :visibility :public)
	(setf *newest-post* (feed-ref entry :published-parsed))))))

(defun main ()
  (multiple-value-bind (opts args) (get-opts)
    (when (or (getf opts :help)
	      (null opts))
      (unix-opts:describe
       :usage-of "rss-bot")

    (when (getf opts :version)
      (format t "rss-bot v~a"
	      (asdf:component-version (asdf:find-system :rss-update-bot)))
      (uiop:quit))
    
    (setf *config-file* (getf opts :config)
	  *url* (getf opts :url)))

  (unless *config-file*
    (format t "ERROR: no config file specified~%")
    (uiop:quit 1))

  (unless *url*
    (format t "ERROR: no url specified~%")
    (uiop:quit 1))

  (handler-case
      (with-user-abort
          (run-bot ((make-instance 'mastodon-bot :config-file *config-file*)
		    :with-websocket nil)
	    (after-every (3 :hours :run-immediately t)
	      (check-feed))))
    (user-abort ()
      (uiop:quit 0))
    (error (e)
      (format t "error: ~a~%" e)
      (uiop:quit 1))))
