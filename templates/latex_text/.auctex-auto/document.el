;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "document"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("fontspec" "") ("nicematrix" "")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "fontspec"
    "nicematrix"))
 :latex)

