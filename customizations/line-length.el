(setq-default
 whitespace-line-column 80
 whitespace-style       '(face lines-tail))

(add-hook 'prog-mode-hook #'whitespace-mode)
