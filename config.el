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
(setq doom-theme 'doom-one-light)


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
;;(require 'company)
;;(setq company-idle-delay 0.2
;;       company-minimum-prefix-length 3)
;;(after! 'irony (setq irony-additional-clang-options '(
;;  "-I/usr/local/include"
;;                                                      )))
;;(setq irony-additional-clang-options '(
;;    "-I/usr/local/opt/llvm/include/c++/v1/"
;;    "-I/usr/local/opt/llvm/include"

;; ))
;;
;;

(after! hl-fill-column
  (custom-set-faces! '(hl-fill-column-face :foreground "black" :background "grey"))
)

(map! :ne "M-/" #'comment-or-uncomment-region)
(setq +word-wrap-extra-indent 'double)
(setq +latex-viewers '(pdf-tools))

(after! lsp-ui
  (custom-set-faces! '(lsp-ui-sideline-code-action :foreground "blue"))
  (set-lookup-handlers! 'lsp-ui-mode nil)
)

(after! lsp-mode
  (setq lsp-diagnostics-attributes '((unnecessary :background "gray")
 (deprecated :strike-through t)))
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

(use-package! org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("[#A]", "[#B]", "[#C]", "[#O]")))

(after! org
  (add-to-list 'org-agenda-files "~/org/gcal.org")
  (add-to-list 'org-agenda-files "~/org/labs.org")
  (setq org-capture-templates
    '(("i" "inbox" entry (file "~/Dropbox/org/inbox.org") "* TODO %?")
      ("t" "today" entry (file "~/Dropbox/org/todo.org") "* TODAY %?")))
  (add-to-list 'org-modules 'org-habit t)
  (setq org-agenda-start-day nil)
  (setq org-highest-priority ?A)
  (setq org-lowest-priority ?D)
  (setq org-log-done 'time)
  (setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "TODAY(o)"  "SUBMIT(s)" "|" "DONE(d)" "CANCELLED(c)")))
  (setq org-priority-faces
        '((65 . "#131E3A") (66 . "#1134A6") (67 . "#6693F5") (68 . "#4D516D")))
  (setq org-ellipsis " ▾ ")
  (setq org-tag-alist '((:startgroup . nil)
                      ("@school" . ?w) ("@personal" . ?h) ("@jobs" . ?j)
                      (:endgroup . nil))
  )
)

(after! org-agenda
  ;; (map! :leader
  ;;   ( :prefix "m"
  ;;    "p" #'org-agenda-priority
  ;;     ))
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
         (todo "SUBMIT"
           ((org-agenda-overriding-header "To Submit")
             (org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/projects.org" "~/Dropbox/org/habits.org"))
             )
           )
         (todo "TODAY"
           ((org-agenda-overriding-header "Today")
             (org-agenda-files '("~/Dropbox/org/todo.org" "~/Dropbox/org/projects.org" "~/Dropbox/org/habits.org"))))
         (todo "NEXT"
           ((org-agenda-overriding-header "In Progress")
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


(setq lsp-signature-auto-activate nil)
