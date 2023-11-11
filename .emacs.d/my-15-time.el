
;; *** =========     REAL  WORLD   / META    ============ ;;
(require 'solar)
(setq calendar-latitude 48.14816)
(setq calendar-longitude 17.10674)
(setq calendar-location-name "Bratislava, SVK")
(setq calendar-time-zone 60) ; UTC+1 in minutes
(setq calendar-daylight-time-offset 60) ; DST in minutes
(setq calendar-daylight-saving-starts '(calendar-nth-named-day 1 0 3)) ; First Sunday in March
(setq calendar-daylight-saving-ends '(calendar-nth-named-day -1 0 10)) ; Last Sunday in October

(use-package all-the-icons)
(defvar my-sunrise-icon (all-the-icons-faicon "sun-o" :v-adjust 0.0 :height 1.2 :face '(:foreground "gold")))
(defvar my-sunset-icon (all-the-icons-faicon "sun-o" :v-adjust 0.0 :height 1.2 :face '(:foreground "orange")))
(defvar my-moon-icon (all-the-icons-faicon "moon-o" :v-adjust 0.0 :height 1.2 :face '(:foreground "lightgray")))

(defun decimal-to-time (decimal)
  (let ((hours (floor decimal))
        (minutes (floor (* 60 (- decimal (floor decimal))))))
    (format "%02d:%02d" hours minutes)))


(defun my/get-sunset (date-spec)
  "Get sunset time in decimal hours for a given date spec.
DATE-SPEC can be 'today, 'tomorrow, or a specific date list like '(month day year)."
  (let* ((date (cond
                ((eq date-spec 'today) (calendar-current-date))
                ((eq date-spec 'tomorrow)
                 (let ((today (calendar-current-date)))
                   (list (car today) (cadr today) (+ 1 (caddr today)))))
                ((listp date-spec) date-spec)))
         (data (solar-sunrise-sunset date))
         (sunset-decimal (car (nth 1 data))))
    sunset-decimal))

(defun my/get-sunrise (date-spec)
  "Get sunrise time in decimal hours for a given date spec.
DATE-SPEC can be 'today, 'tomorrow, or a specific date list like '(month day year)."
  (let* ((date (cond
                ((eq date-spec 'today) (calendar-current-date))
                ((eq date-spec 'tomorrow)
                 (let ((today (calendar-current-date)))
                   (list (car today) (cadr today) (+ 1 (caddr today)))))
                ((listp date-spec) date-spec)))
         (data (solar-sunrise-sunset date))
         (sunrise-decimal (car (nth 0 data))))
    sunrise-decimal))
(my/get-sunrise 'today)
(my/get-sunset 'tomorrow)
(message "%s" "gut")



(defun my/sunset-sunrise ()
  (interactive)
  (let* (
         (sunset-time (decimal-to-time (my/get-sunset 'today)))
         (sunrise-time  (decimal-to-time (my/get-sunrise 'tomorrow)))
        ) 
        (message "Sunset %s%s\n Sunrise %s%s"
            my-moon-icon sunset-time
            my-sunrise-icon sunrise-time)
   )
)

(provide 'my-15-time)
;;; my-15-time.el ends here

