;;; elfeed-db-classic.el --- the classic elfeed database format -*- lexical-binding: t; -*-

;; This is free and unencumbered software released into the public domain.

;; Author: Andrew Chi <chifamicom@outlook.com>

;;; Commentary:

;; This is an implementation of the elfeed-db-* functions with the
;; classic elfeed format.

;;; Code:

(require 'elfeed-db)

(cl-defstruct elfeed-db-classic
  "The classic elfeed database."
  ((feeds :documentation "Feeds hash table.")
   (entries :documentation "Entries hash table.")
   (index :documentation "Collection of all entries sorted by date.")))

(cl-defmethod elfeed-db-get-feed-1 ((db elfeed-db-classic) id)
  (with-memoization (gethash id (elfeed-db-classic-feeds db))
    (elfeed-feed--create :id id)))

(cl-defmethod elfeed-db-get-entry-1 ((db elfeed-db-classic) id)
  (gethash id (elfeed-db-classic-entries db)))

(cl-defmethod elfeed-db-set-update-time-1 ((db elfeed-db-classic))
  "Update the database last-update time."
  (plist-put db :last-update (float-time)))

;; (cl-defmethod elfeed-db-add-1 ((db elfeed-db-classic)
;;                                entries)
;;   (cl-loop for entry in entries
;;            for id = (elfeed-entry-id entry)
;;            for original = (gethash id elfeed-db-entries)
;;            for new-date = (elfeed-entry-date entry)
;;            for original-date = (and original (elfeed-entry-date original))
;;            do (elfeed-deref-entry entry)
;;            when original count
;;            (if (= new-date original-date)
;;                (elfeed-entry-merge original entry)
;;              (avl-tree-delete elfeed-db-index id)
;;              (prog1 (elfeed-entry-merge original entry)
;;                (avl-tree-enter elfeed-db-index id)))
;;            into change-count
;;            else count
;;            (setf (gethash id elfeed-db-entries) entry)
;;            into change-count
;;            and do
;;            (progn
;;              (avl-tree-enter elfeed-db-index id)
;;              (run-hook-with-args 'elfeed-new-entry-hook entry))
;;            finally
;;            (unless (zerop change-count)
;;              (elfeed-db-set-update-time)))
;;   :success)

(provide 'elfeed-db-classic)

;;; elfeed-db-classic.el ends here
