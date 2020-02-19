;;;; rss-update-bot.lisp

(in-package #:rss-update-bot)

(defun check-feeds ()
  "check all feed URLs"
  (dolist (url *urls*)
    (handler-case
	(let ((feed (parse-feed (dex:get url) :max-entries 10)))
	  (unless (gethash url *newest-post*)
	    (setf (gethash url *newest-post*)
		  (get-universal-time)))
    
	  (dolist (entry (reverse (feed-ref feed :entries)))
	    (when (> (feed-ref entry :published-parsed)
		     (gethash url *newest-post* 0))
	      (post (format nil "~a~%~%~a"
			    (feed-ref entry :title)
			    (feed-ref entry :link))
		    :visibility :public)
	      (setf (gethash url *newest-post*)
		    (feed-ref entry :published-parsed)))))
      
      (error (e)
	(format t "error: ~a~%" e)))))

(defun main ()
  "binary entry point"
  (multiple-value-bind (opts args) (get-opts)
    (when (or (getf opts :help)
	      (null opts))
      (unix-opts:describe
       :usage-of "rss-bot"
       :args "URLS")
      (uiop:quit))

    (when (getf opts :version)
      (format t "rss-bot v~a"
	      (asdf:component-version (asdf:find-system :rss-update-bot)))
      (uiop:quit))
    
    (setf *config-file* (getf opts :config)
	  *urls* args))

  (unless *config-file*
    (format t "ERROR: no config file specified~%")
    (uiop:quit 1))

  (unless *urls*
    (format t "ERROR: no url specified~%")
    (uiop:quit 1))
  
  (handler-case
      (with-user-abort
          (run-bot ((make-instance 'mastodon-bot :config-file *config-file*)
		    :with-websocket nil)
	    (after-every ((conf:config :poll-interval 3) :hours
			  :run-immediately t)
	      (check-feeds))))

    (user-abort ()
      (uiop:quit 0))

    (error (e)
      (format t "error: ~a~%" e)
      (uiop:quit 1))))
