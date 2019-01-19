(defun tdd-test ()
  "Thin wrapper around `cider-test-run-tests'."
  (when (cider-connected-p)
    (let ((cider-auto-select-test-report-buffer nil)
          (cider-test-show-report-on-success nil))
      (cider-test-run-ns-tests nil))))

(define-minor-mode tdd-mode
  "Run all tests whenever a file is saved."
  t nil nil
  :global t
  (if tdd-mode
      (add-hook 'cider-file-loaded-hook #'tdd-test)
    (remove-hook 'cider-file-loaded-hook #'tdd-test)))
