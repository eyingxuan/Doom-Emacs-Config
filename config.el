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
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
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

(map! :ne "M-/" #'comment-or-uncomment-region)
(setq +word-wrap-extra-indent 'double)
(setq +latex-viewers '(pdf-tools))

(after! org-fancy-priorities
  (setq org-fancy-priorities-list '("HIGH", "MID", "LOW", "OPTIONAL")))

(after! org
  (add-to-list 'org-modules 'org-habit t)
  (setq org-highest-priority ?A)
  (setq org-lowest-priority ?D)
  (setq org-log-done 'time)
  (setq org-priority-faces
        '((65 . "#131E3A") (66 . "#1134A6") (67 . "#6693F5") (68 . "#4D516D")))
  (setq org-ellipsis " ▾ ")
  (setq org-tag-alist '((:startgroup . nil)
                      ("@school" . ?w) ("@personal" . ?h) ("@jobs" . ?j)
                      (:endgroup . nil))
  )
)

(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-super-agenda-header-map nil)
  (setq org-super-agenda-groups '((:name "Today"
                                  :time-grid t
                                  :scheduled today)
                           (:name "Due today"
                                  :deadline today)
                           (:name "Important"
                                  :priority "A")
                           (:name "Overdue"
                                  :deadline past)
                           (:name "Due soon"
                                  :deadline future)))
  :config
  (org-super-agenda-mode)
)

(use-package! calfw-ical
  :after calfw)

(after! calfw
  (define-key cfw:calendar-mode-map (kbd "SPC") 'doom/leader)
  (define-key cfw:calendar-mode-map (kbd "d") 'cfw:show-details-command)
)



(use-package! org-gcal
  :after org-agenda
  :config
  (load "~/.doom.d/orgcal.el")
)




(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source (face-foreground 'default)); orgmode source
)))

(setq +calendar-open-function #'my-open-calendar)
