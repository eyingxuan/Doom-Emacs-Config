;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Yingxuan Eng"
      user-mail-address "engyingxuan@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
(setq doom-font (font-spec :family "Hack" :size 16)
      doom-variable-pitch-font (font-spec :family "Noto Sans"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-dracula)


;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/Dropbox/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - add-load-path! for adding directories to the load-path, where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.


(map! :ne "M-/" #'comment-or-uncomment-region)
(setq +word-wrap-extra-indent 'double)
(setq +latex-viewers '(pdf-tools))

(setq read-process-output-max (* 1024 1024))

(after! lsp-ui
  (set-lookup-handlers! 'lsp-ui-mode nil)
  )

(after! lsp-mode
  (setq lsp-diagnostics-attributes '((unnecessary :background "gray")
                                     (deprecated :strike-through t)))
  (setq lsp-pyls-configuration-sources ["flake8"])
  (setq lsp-pyls-plugins-flake8-enabled t)
  )

(after! tuareg
  ;; (set-lookup-handlers! 'tuareg-mode :async t
  ;;   :definition #'merlin-locate
  ;;   :references #'merlin-occurrences
  ;;   :documentation #'merlin-document)
  (remove-hook! 'tuareg-mode-local-vars-hook #'flyspell-prog-mode)
  )

(after! merlin
  (setq merlin-locate-in-new-window 'never))

(after! hl-line
  (remove-hook! (prog-mode text-mode conf-mode) #'hl-line-mode))

(add-hook! (prog-mode) #'display-fill-column-indicator-mode)

(use-package! org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("[#A]", "[#B]", "[#C]", "[#O]")))

(after! org
  (add-to-list 'org-agenda-files "~/org/gcal.org")
  (add-to-list 'org-agenda-files "~/org/labs.org")
  (setq org-capture-templates
        '(("i" "inbox" entry (file "~/Dropbox/org/inbox.org") "* TODO %?")
          ("t" "instant" entry (file "~/Dropbox/org/todo.org") "* TODO %? %^g")))
  (add-to-list 'org-modules 'org-habit t)
  (setq org-agenda-start-day nil)
  (setq org-highest-priority ?A)
  (setq org-lowest-priority ?D)
  (setq org-log-done 'time)
  (setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)" "CANCELLED(c)")))
  ;; (setq org-priority-faces
  ;;       '((65 . "#131E3A") (66 . "#1134A6") (67 . "#6693F5") (68 . "#4D516D")))
  (setq org-ellipsis " ▾ ")
  (setq org-tag-alist '((:startgroup . nil)
                        ("@school" . ?w) ("@personal" . ?h) ("@jobs" . ?j)
                        (:endgroup . nil)
                        (:startgroup . nil)
                        ("@today" . ?t)
                        ("@submit" . ?s)
                        ("@progress" .?p)
                        ("@blocked" . ?b)
                        (:endgroup . nil)
                        )
        )
  )

(after! org-agenda
  ;; (map! :leader
  ;;   ( :prefix "m"
  ;;    "p" #'org-agenda-priority
  ;;     ))
  ;;




  (map! (:map org-agenda-mode-map :localleader "p" #'org-agenda-priority))
  (advice-add 'org-refile :after
              (lambda (&rest _)
                (org-save-all-org-buffers)))
  (defun org-agenda-process-inbox-item()
    (org-with-wide-buffer
     (org-agenda-set-tags)
     (org-agenda-priority)
     (call-interactively 'org-agenda-set-effort)
     (org-agenda-refile nil nil t))
    )
  (setq ying/org-agenda-todo-view
        `("c" "Agenda"
          ((agenda ""
                   ((org-agenda-span 'day)
                    (org-deadline-warning-days 365)))
           (todo "TODO"
                 ((org-agenda-overriding-header "To Refile")
                  (org-agenda-files '("~/Dropbox/org/inbox.org"))))
           (tags-todo "@today"
                      ((org-agenda-overriding-header "Today")
                       (org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/projects.org" "~/Dropbox/org/habits.org"))))
           (tags-todo "@progress"
                      ((org-agenda-overriding-header "In Progress")
                       (org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/projects.org" "~/Dropbox/org/habits.org")
                                         )))
           (tags-todo "@blocked"
                      ((org-agenda-overriding-header "Blocked")
                       (org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/projects.org" "~/Dropbox/org/habits.org")
                                         )))
           (tags-todo "@submit"
                      ((org-agenda-overriding-header "Submit")
                       (org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/projects.org" "~/Dropbox/org/habits.org")
                                         )))
           (todo "TODO"
                 ((org-agenda-overriding-header "Projects")
                  (org-agenda-files '("~/Dropbox/org/projects.org")))
                 )
           (todo "TODO"
                 ((org-agenda-overriding-header "One-off Tasks")
                  (org-agenda-files '("~/Dropbox/org/todo.org"))
                  (org-agenda-skip-function '(org-agenda-skip-entry-if 'deadline 'scheduled))
                  )
                 ))
          nil))
  (add-to-list 'org-agenda-custom-commands `,ying/org-agenda-todo-view)
  )


(after! calfw
  (define-key cfw:calendar-mode-map (kbd "SPC") #'doom/leader)
  (define-key cfw:calendar-mode-map (kbd "d") #'cfw:show-details-command)
  )

;; (after! rust
;;   (setq rustic-indent-offset 2))

(after! org-gcal
  (load "~/.doom.d/orgcal.el"))


(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source (face-foreground 'default)); orgmode source
    )))

(defun ying/org-agenda-process-inbox-item()
  (interactive)
  (org-with-wide-buffer
   (org-agenda-set-tags)
   (org-agenda-priority)
   (call-interactively 'org-agenda-set-effort)
   (org-agenda-refile nil nil t))
  )

(setq +calendar-open-function #'my-open-calendar)

(after! tex
  (setq font-latex-fontify-script nil))

(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))


(after! editorconfig
  (add-to-list 'editorconfig-indentation-alist '(rjsx-mode js2-basic-offset
                                                           sgml-basic-offset))
  )


(add-hook 'TeX-mode-hook
          (lambda()
            (add-hook 'after-save-hook
                      (lambda()
                        (TeX-run-latexmk "LaTeX"
                                         (format "latexmk -pdf --synctex=1 %s" (concat "'" buffer-file-name "'"))
                                         (file-name-base (buffer-file-name)))) nil t)))


(if (not (display-graphic-p))
    (custom-set-faces! '(default :background "unspecified-bg"))
  )

(use-package! multi-vterm
  :config
  (add-hook 'vterm-mode-hook
            (lambda ()
              (setq-local evil-insert-state-cursor 'box)
              (evil-insert-state)))
  (define-key vterm-mode-map [return]                      #'vterm-send-return)

  (setq vterm-keymap-exceptions nil)
  (evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
  (evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
  (evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
  (evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
  (evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
  (evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
  (evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
  (evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))

(setq projectile-indexing-method 'hybrid)
(setq rustic-lsp-server 'rust-analyzer)
(setq lsp-signature-auto-activate nil)


(after! irony
  (setq irony-additional-clang-options [
                                        "-I/usr/local/include"
                                        "-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/../include/c++/v1"
                                        "-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/clang/11.0.3/include"
                                        "-I/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include"
                                        "-I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include"
                                        ]))

(defun disable-c++-namespace ()
  (c-set-offset 'innamespace [0]))
(add-hook 'c++-mode-hook 'disable-c++-namespace)


(use-package! org-roam
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory "~/Dropbox/org/brain/")
  )

(use-package! org-wild-notifier
  :after (org)
  :hook (org-agenda-mode . org-wild-notifier-mode)
  :config
  (setq alert-default-style 'notifier)
  (setq org-wild-notifier-alert-time '(3))
  )



(use-package! org-roam-server
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8081
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))



(setq deft-directory "~/Dropbox/org/brain")

(after! tide
  (flycheck-add-mode 'tsx-tide 'typescript-tsx-mode)
  (flycheck-add-next-checker 'tsx-tide '(error . javascript-eslint))
  (flycheck-add-next-checker 'typescript-tide '(error . javascript-eslint))
  )

(use-package! lsp-haskell
 :config
 (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
 ;; Comment/uncomment this line to see interactions between lsp client/server.
 ;;(setq lsp-log-io t)
)
