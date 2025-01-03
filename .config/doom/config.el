(use-package! gcmh
:init
(setq gcmh-idle-delay 5
      gcmh-high-cons-threshold (* 256 1024 1024))  ; 256MB during idle
:config
(gcmh-mode 1))

(setq gc-cons-threshold 200000000) ; previous 33554432

;; credentials
(setq user-full-name "Fredrik Dahlström"
      user-mail-address "fredahl71@gmail.com")

;; autosave and backup
(setq auto-save-default t
      make-backup-files t)

;; kill emacs without confirming
(setq confirm-kill-emacs nil)

;; remap <localleader> from SPC m to SPC l
(setq doom-localleader-key "SPC l"
      doom-localleader-alt-key "M-SPC l")

(require 'corral)

;; recommended to use with US keyboard layout
(global-set-key (kbd "M-9") 'corral-parentheses-backward)
(global-set-key (kbd "M-0") 'corral-parentheses-forward)
(global-set-key (kbd "M-[") 'corral-brackets-backward)
(global-set-key (kbd "M-]") 'corral-brackets-forward)
(global-set-key (kbd "M-{") 'corral-braces-backward)
(global-set-key (kbd "M-}") 'corral-braces-forward)
(global-set-key (kbd "M-\"") 'corral-double-quotes-backward)

(if (featurep :system 'macos)
    (setq mac-option-modifier nil
          mac-command-modifier 'meta
          mac-right-option-modifier nil
          x-select-enable-clipboard t))

(setq doom-theme 'doom-gruvbox)

(setq doom-font (font-spec :family "SF Mono" :size 15.5)
      doom-serif-font (font-spec :family "ETBembo" :size 15.5)
      doom-variable-pitch-font (font-spec :family "ETBembo" :size 20)
      doom-emoji-font (font-spec :family "Apple Color Emoji" :size 15.5)
      doom-symbol-font (font-spec :family "Cascadia Code" :size 15.5))

(setq display-line-numbers-type 'relative) ;; TODO change to 'visual in org-mode

(add-hook! display-line-numbers-mode
           (custom-set-faces!
             '(line-number :slint normal)
             '(line-number-current-line :slant normal)))

(setq global-hl-line-modes nil)

(setq display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(pixel-scroll-precision-mode 1)

(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 40))

(setq frame-title-format
      '(""
        (:eval
         (if (s-contains-p org-roam-directory (or buffer-file-name ""))
             (replace-regexp-in-string
              ".*/[0-9]*-?" "☰ "
              (subst-char-in-string ?_ ?  buffer-file-name))
           "%b"))
        (:eval
         (let ((project-name (projectile-project-name)))
           (unless (string= "-" project-name)
             (format (if (buffer-modifier-p) " ◉ %s" "  ●  %s") project-name)))))

(after! corfu
  (setq corfu-auto nil
        corfu-preselect 'first
        +corfu-want-tab-prefer-expand-snippets t))

(after! (evil copilot)
  (evil-define-key 'insert 'global (kbd "<tab>") 'copilot-accept-completion))

(map! :leader
      (:prefix ("e" . "copilot")
       :desc "Enable Copilot Mode"
       "c" #'copilot-mode
       :desc "Display Chat Window"
       "d" #'copilot-chat-display
       :desc "Explain Selected Code"
       "e" #'copilot-chat-explain
       :desc "Review Selected Code"
       "r" #'copilot-chat-review
       :desc "Fix Selected Code"
       "f" #'copilot-chat-fix
       :desc "Optimize Selected Code"
       "o" #'copilot-chat-optimize
       :desc "Write Test for Code"
       "t" #'copilot-chat-test
       :desc "Add Current Buffer"
       "a" #'copilot-chat-add-current-buffer
       :desc "Document Selected Code"
       "D" #'copilot-chat-doc
       :desc "Reset Chat History"
       "R" #'copilot-chat-reset
       :desc "Remove Current Buffer"
       "x" #'copilot-chat-del-current-buffer))

(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-shortmenu)

(add-hook! '+doom-dashboard-functions :append
  (insert "\n" (+doom-dashboard--center +doom-dashboard--width "Welcome back to Emacs!"))
  (setq mode-line-format nil)
  (hl-line-mode 0)
  (read-only-mode +1))

(setq-hook! '+doom-dashboard-mode-hook evil-normal-state-cursor (list nil))

(defun my-weebery-is-always-greater ()
  (let* ((banner '("⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀"
                   "⢸⠉⣹⠋⠉⢉⡟⢩⢋⠋⣽⡻⠭⢽⢉⠯⠭⠭⠭⢽⡍⢹⡍⠙⣯⠉⠉⠉⠉⠉⣿⢫⠉⠉⠉⢉⡟⠉⢿⢹⠉⢉⣉⢿⡝⡉⢩⢿⣻⢍⠉⠉⠩⢹⣟⡏⠉⠹⡉⢻⡍⡇"
                   "⢸⢠⢹⠀⠀⢸⠁⣼⠀⣼⡝⠀⠀⢸⠘⠀⠀⠀⠀⠈⢿⠀⡟⡄⠹⣣⠀⠀⠐⠀⢸⡘⡄⣤⠀⡼⠁⠀⢺⡘⠉⠀⠀⠀⠫⣪⣌⡌⢳⡻⣦⠀⠀⢃⡽⡼⡀⠀⢣⢸⠸⡇"
                   "⢸⡸⢸⠀⠀⣿⠀⣇⢠⡿⠀⠀⠀⠸⡇⠀⠀⠀⠀⠀⠘⢇⠸⠘⡀⠻⣇⠀⠀⠄⠀⡇⢣⢛⠀⡇⠀⠀⣸⠇⠀⠀⠀⠀⠀⠘⠄⢻⡀⠻⣻⣧⠀⠀⠃⢧⡇⠀⢸⢸⡇⡇"
                   "⢸⡇⢸⣠⠀⣿⢠⣿⡾⠁⠀⢀⡀⠤⢇⣀⣐⣀⠀⠤⢀⠈⠢⡡⡈⢦⡙⣷⡀⠀⠀⢿⠈⢻⣡⠁⠀⢀⠏⠀⠀⠀⢀⠀⠄⣀⣐⣀⣙⠢⡌⣻⣷⡀⢹⢸⡅⠀⢸⠸⡇⡇"
                   "⢸⡇⢸⣟⠀⢿⢸⡿⠀⣀⣶⣷⣾⡿⠿⣿⣿⣿⣿⣿⣶⣬⡀⠐⠰⣄⠙⠪⣻⣦⡀⠘⣧⠀⠙⠄⠀⠀⠀⠀⠀⣨⣴⣾⣿⠿⣿⣿⣿⣿⣿⣶⣯⣿⣼⢼⡇⠀⢸⡇⡇⠇"
                   "⢸⢧⠀⣿⡅⢸⣼⡷⣾⣿⡟⠋⣿⠓⢲⣿⣿⣿⡟⠙⣿⠛⢯⡳⡀⠈⠓⠄⡈⠚⠿⣧⣌⢧⠀⠀⠀⠀⠀⣠⣺⠟⢫⡿⠓⢺⣿⣿⣿⠏⠙⣏⠛⣿⣿⣾⡇⢀⡿⢠⠀⡇"
                   "⢸⢸⠀⢹⣷⡀⢿⡁⠀⠻⣇⠀⣇⠀⠘⣿⣿⡿⠁⠐⣉⡀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠳⠄⠀⠀⠀⠀⠋⠀⠘⡇⠀⠸⣿⣿⠟⠀⢈⣉⢠⡿⠁⣼⠁⣼⠃⣼⠀⡇"
                   "⢸⠸⣀⠈⣯⢳⡘⣇⠀⠀⠈⡂⣜⣆⡀⠀⠀⢀⣀⡴⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢽⣆⣀⠀⠀⠀⣀⣜⠕⡊⠀⣸⠇⣼⡟⢠⠏⠀⡇"
                   "⢸⠀⡟⠀⢸⡆⢹⡜⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠋⣾⡏⡇⡎⡇⠀⡇"
                   "⢸⠀⢃⡆⠀⢿⡄⠑⢽⣄⠀⠀⠀⢀⠂⠠⢁⠈⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠄⡐⢀⠂⠀⠀⣠⣮⡟⢹⣯⣸⣱⠁⠀⡇"
                   "⠈⠉⠉⠉⠉⠉⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁"))
         (longest-line (apply #'max (mapcar #'length banner))))
    (put-text-property
     (point)
     (dolist (line banner (point))
       (insert (+doom-dashboard--center
                +doom-dashboard--width
                (concat line (make-string (max 0 (- longest-line (length line))) 32)))
               "\n"))
     'face 'doom-dashboard-banner)))

(setq +doom-dashboard-ascii-banner-fn #'my-weebery-is-always-greater)

(after! doom-modeline
  (setq doom-modeline-buffer-file-name-style 'file-name
        doom-modeline-always-show-macro-register t
        doom-modeline-enable-word-count nil
        doom-modeline-buffer-encoding t
        doom-modeline-major-mode-icon t
        doom-modeline-bar-width 0
        doom-modeline-height 25
        doom-modeline-modal nil))

(add-hook! 'org-mode-hook #'mixed-pitch-mode)

(after! mixed-pitch
  (setq mixed-pitch-set-height t)
  (setq variable-pitch-serif-font doom-variable-pitch-font)
  (set-face-attribute 'variable-pitch nil :height 1.2))

(use-package! spacious-padding
  :ensure t
  :config
  (setq spacious-padding-widths
        '( :internal-border-width 15
           :header-line-width 4
           :mode-line-width 4
           :tab-width 4
           :right-divider-width 30
           :scroll-bar-width 8
           :fringe-width 0))
  (spacious-padding-mode 1))

(after! dirvish
  (setq! dirvish-quick-access-entries
         `(("h" "~/"           "Home")
           ("e" ,doom-user-dir "Doom config")
           ("c" "~/Developer/" "Code")
           ("d" "~/Downloads/" "Downloads")
           ("g" "~/GitHub/"    "GitHub")
           ("t" "~/.Trash/"    "Trash"))))

(use-package! eglot-booster
  :after eglot
  :config (eglot-booster-mode))

(after! cc-mode
  (setq c-basic-offset 2))

(after! go-mode
  (setq c-basic-offset 2))

(after! java-mode
  (setq c-basic-offset 2))

(map! :map cdlatex-mode-map
      :i "TAB" #'cdlatex-tab)

(map! :after latex
      :map cdlatex-mode-map
      :localleader
      :desc "Insert math symbol"
      "i" #'cdlatex-math-symbol
      :desc "Begin environment"
      "e" #'cdlatex-environment)

; Set which program to view the PDF-files in.
(setq +latex-viewers '(pdf-tools))

; Set which LSP to use for LaTeX, the popular ones being texlab and digestif.
(setq lsp-tex-server 'texlab)

; Enable xenops (for rendering maths, tables, tikz, executing code, etc.)
(add-hook LaTeX-mode-hook #'xenops-mode)

(setq org-directory "~/Documents/Org"
      org-use-property-inheritance t ; fix weird issue with src blocks
      org-startup-with-inline-images t
      org-hide-emphasis-markers t
      org-edit-src-content-indentation 0
      org-startup-with-latex-preview t)

(after! org
  (custom-set-faces!
    `((org-document-title)
      :foreground ,(face-attribute 'org-document-title :foreground)
      :height 1.3 :weight bold)
    `((org-level-1)
      :foreground ,(face-attribute 'outline-1 :foreground)
      :height 1.1 :weight medium)
    `((org-level-2)
      :foreground ,(face-attribute 'outline-2 :foreground)
      :weight medium)
    `((org-level-3)
      :foreground ,(face-attribute 'outline-3 :foreground)
      :weight medium)
    `((org-level-4)
      :foreground ,(face-attribute 'outline-4 :foreground)
      :weight medium)
    `((org-level-5)
      :foreground ,(face-attribute 'outline-5 :foreground)
      :weight medium)))

(after! org
  (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
  (add-to-list 'org-latex-packages-alist '("" "amssymb" t))
  (add-to-list 'org-latex-packages-alist '("" "mathtools" t))
  (add-to-list 'org-latex-packages-alist '("" "mathrsfs" t)))

(use-package! org-latex-preview
  :after org
  :config
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)
  (add-hook 'org-mode-hook 'org-latex-preview-auto-mode)
  (setq org-latex-preview-auto-ignored-commands
        '(next-line previous-line mwheel-scroll
          scroll-up-command scroll-down-command))
  (setq org-latex-preview-numbered t)
  (setq org-latex-preview-live t)
  (setq org-latex-preview-live-debounce 0.25))

(use-package! org-modern
  :after org
  :config
  (setq
   org-auto-align-tags t
   org-tags-column 0
   org-fold-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; agenda
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")

  (global-org-modern-mode))

(use-package! org-roam
  :defer t
  :config
  (setq org-roam-directory (file-truename "~/Notes")
        org-roam-db-location (file-truename "~/Notes/org-roam.db")
        org-attach-id-dir "assets/")
  (org-roam-db-autosync-enable))

(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(map! :map evil-org-mode-map
        :leader
        (:prefix ("r")
         :desc "Insert node"
         "i" #'org-roam-node-insert
         :desc "Find node"
         "f" #'org-roam-node-find
         :desc "Capture to node"
         "c" #'org-roam-capture
         :desc "Toggle roam buffer"
         "b" #'org-roam-buffer-toggle
         :desc "Open random note"
         "r" #'org-roam-node-random
         :desc "Visit node"
         "v" #'org-roam-node-visit
         :desc "Open ORUI"
         "u" #'org-roam-ui-open))

(after! eglot
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio"))))

(add-hook! python-mode
  (setq python-shell-interpreter "python3.12"
        doom-modeline-env-python-executable "python3.12"))
