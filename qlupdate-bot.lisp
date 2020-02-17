;;;; qlupdate-bot.lisp

(in-package #:qlupdate-bot)

(defun check-rss ()
  (let ((feed (parse-feed (dex:get *ql-url*) :max-entries 10)))
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
    (setf *config-file* (getf opts :config)))

  (unless *config-file*
    (format t "ERROR: no config file specific~%")
    (uiop:quit 1))

  (run-bot ((make-instance 'mastodon-bot :config *config-file*)
	    :with-websocket nil)
    (after-every (3 :hours :run-immediately t)
      (check-rss))))
