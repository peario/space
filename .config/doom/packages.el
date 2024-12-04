;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; ORG MODE
(unpin! org)

(package! org :recipe
  (:host nil :repo "https://git.tecosaur.net/mirrors/org-mode.git" :remote "mirror" :fork
   (:host nil :repo "https://git.tecosaur.net/tec/org-mode.git" :branch "dev" :remote "tecosaur")
   :files
   (:defaults "etc")
   :build t :pre-build
   (with-temp-file "org-version.el"
     (require 'lisp-mnt)
     (let
         ((version
           (with-temp-buffer
             (insert-file-contents "lisp/org.el")
             (lm-header "version")))
          (git-version
           (string-trim
            (with-temp-buffer
              (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
              (buffer-string)))))
       (insert
        (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
        (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
        "(provide 'org-version)\n"))))
  :pin nil)

(package! org-roam-ui)
(package! org-modern)
(package! org-bullets)

;; PROGRAMMING
;; (package! copilot
;;   :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el")))

;; (package! copilot-chat
;;   :recipe (:host github :repo "chep/copilot-chat.el" :files ("*.el")))

(package! eglot-booster
  :recipe (:host github :repo "jdtsmith/eglot-booster"))

;; LaTeX
(package! xenops)

;; GoLang


;; UI
(package! solaire-mode :disable t)
(package! spacious-padding)
(package! casual)

;; THEMES
(package! everforest
  :recipe (:host nil
           :repo "https://git.sr.ht/~theorytoe/everforest-theme"
           :files ("everforest-*-theme.el")))
