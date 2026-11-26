;; -*- lexical-binding: t; -*-


;; Tắt scroll bar 
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; fix dwm
(setq frame-resize-pixelwise t)
;; line number
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)





;; 1. KHAI BÁO KHO MELPA
(require 'package)
(setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

;; 2. CÀI ĐẶT VÀ KÍCH HOẠT USE-PACKAGE (Nếu chưa có)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; Using theme
(use-package dracula-theme
  :ensure t
  :init
  ;; Nếu gặp lỗi chưa có package trên máy, ép làm mới bộ đệm để lấy link mới nhất
  (unless (package-installed-p 'dracula-theme)
    (package-refresh-contents))
  :config
  (load-theme 'dracula t))

;; 3. CẤU HÌNH CONDA VÀ EVIL MODE BẰNG USE-PACKAGE
(use-package conda
  :ensure t
  :init
  ;; Đường dẫn này phải đúng với thư mục anaconda/miniconda trên máy
  (setq conda-anaconda-home (expand-file-name "~/Applications/Linux/Miniconda"))
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell))

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)

  ;; Sử dụng key-chord để bấm đồng thời hoặc bấm nhanh jk/kj trong Insert Mode
  (use-package key-chord
    :ensure t
    :config
    (key-chord-mode 1)
    ;; Đặt thời gian trễ giữa 2 phím (mặc định là 0.1 giây, bạn có thể tăng lên nếu gõ chưa quen)
    (setq key-chord-two-keys-delay 0.15) 
    
    ;; Gán phím tắt cho Insert Mode (evil-insert-state-map)
    (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
    (key-chord-define evil-insert-state-map "kj" 'evil-normal-state)))



;; EMACS' config auto generation 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(code-cells company conda hl-todo jupyter)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )




;; 4. CẤU HÌNH TRỰC QUAN CHO JUPYTER REPL
;; Gom toàn bộ text output và hình ảnh đồ thị trực tiếp vào buffer REPL
(setq jupyter-repl-echo-eval-p t)

;; Ngăn không cho Emacs tự động bật popup cửa sổ jupyter-display
(setq jupyter-display-buffer-presentation-action nil)

;; Tự động bật chế độ chia cell mỗi khi bạn mở file Python
(add-hook 'python-mode-hook 'code-cells-mode-maybe)

;; 5. CẤU HÌNH GÓI CODE-CELLS (CHIA Ô CHẠY MÃ # %%)
(with-eval-after-load 'code-cells
  ;; Hàm trung gian đã được sửa lại: thêm tham số nil ở đầu để khớp với jupyter-eval-region mới
  (defun my/jupyter-eval-cell (beg end)
    "Sửa lỗi truyền tham số giữa code-cells và emacs-jupyter."
    (interactive "r")
    (jupyter-eval-region nil beg end))

  ;; Ép code-cells gọi hàm trung gian vừa tạo thay vì gọi trực tiếp jupyter
  (setq code-cells-eval-region-commands
        '((jupyter-repl-interaction-mode . my/jupyter-eval-cell)))
  
  ;; --- BỘ PHÍM TẮT CHUẨN JUPYTER NOTEBOOK ---
  ;; Shift + Enter: Chạy cell hiện tại và nhảy sang cell tiếp theo
  (define-key code-cells-mode-map (kbd "S-<return>") 'code-cells-eval-and-step)
  ;; Ctrl + Enter: Chỉ chạy cell hiện tại và đứng yên
  (define-key code-cells-mode-map (kbd "C-<return>") 'code-cells-eval)
  ;; Alt + Enter: Chạy toàn bộ cell 
  (define-key code-cells-mode-map (kbd "M-<return>") 'jupyter-eval-buffer)
  ;; Alt + n / Alt + p: Nhảy nhanh qua lại giữa các ô lệnh mà không chạy mã
  (define-key code-cells-mode-map (kbd "M-n") 'code-cells-forward-cell)
  (define-key code-cells-mode-map (kbd "M-p") 'code-cells-backward-cell))



;; 6. TỐI ƯU HÓA CUỘN MƯỢT (PIXEL SCROLL) KHI GẶP ẢNH TO
(if (fboundp 'pixel-scroll-precision-mode)
    (pixel-scroll-precision-mode 1)
  (pixel-scroll-mode 1))
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)


;; 7. CẤU HÌNH TỰ ĐỘNG HOÀN THÀNH CODE (COMPANY + JUPYTER + PYRIGHT)
(use-package company
  :ensure t
  :config
  (global-company-mode 1)
  (setq company-idle-delay 0.3)         ; Hiện menu gợi ý siêu nhanh sau 0.1 giây
  (setq company-minimum-prefix-length 3) ; Gõ 1 ký tự là bắt đầu gợi ý
  (setq company-tooltip-limit 10)
    ;; Giới hạn số lượng hàm tính toán giúp giảm giật lag khi cuộn menu gợi ý
  (setq company-transformers '(company-sort-by-occurrence))

  ;; Đồng bộ phím tắt chọn từ với Evil Mode (Vim)
  (with-eval-after-load 'evil
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous)

    ;; --- BỘ PHÍM TẮT VIM THEO CHUẨN ]d VÀ [d ---
    ;; Nhấn ]d trong chế độ Normal Mode để nhảy đến lỗi tiếp theo phía dưới
    (define-key evil-normal-state-map (kbd "]d") 'flymake-goto-next-error)
    ;; Nhấn [d trong chế độ Normal Mode để nhảy ngược lên lỗi phía trên
    (define-key evil-normal-state-map (kbd "[d") 'flymake-goto-prev-error)))

;; 8. CẤU HÌNH BỘ NÃO KIỂM TRA LỖI VÀ GỢI Ý (LSP QUA EGLOT ĐỒNG BỘ CONDA)
(use-package eglot
  :ensure nil
  :hook
  (python-mode . (lambda ()
                   ;; Ép Emacs nạp thư mục bin của Conda vào hệ thống thực thi
                   (when (bound-and-true-p conda-env-current-path)
                     (add-to-list 'exec-path (expand-file-name "bin" conda-env-current-path))
                     (setenv "PATH" (concat (expand-file-name "bin" conda-env-current-path) ":" (getenv "PATH"))))
                   (eglot-ensure)
                   (flymake-mode 1)))
  :config
  ;; Đổi lệnh gọi thành "pylsp" thuần Python tương thích Conda 100%
  (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))


  ;; --- THÊM ĐOẠN NÀY ĐỂ GIẢM LAG FLYMAKE ---
  (setq flymake-no-changes-timeout 1.5) ; Chỉ quét lỗi nếu dừng gõ quá 1.5 giây
  ;; HOẶC nếu vẫn lag, dùng dòng dưới để CHỈ quét lỗi khi bấm Lưu file:
  ;; (setq flymake-no-changes-timeout nil) 


  ;; Đồng bộ lỗi sang Flymake và gộp Autocomplete sang Company
  (with-eval-after-load 'company
    (add-hook 'eglot-managed-mode-hook
              (lambda ()
                (setq-local flymake-diagnostic-functions '(eglot-flymake-backend))
                (setq-local company-backends
                            '((company-capf :with company-yasnippet)))))))


;; Tắt việc Eglot tự động hiện tài liệu/chữ ở đáy màn hình khi di chuyển con trỏ (Giảm lag cực mạnh)
(setq eldoc-idle-delay 1) ; Chỉ hiện sau khi con trỏ đứng yên 0.5 giây

;; ==========================================
;; 10. TỰ ĐỘNG HÓA CONDA VÀ BẢNG LỖI ĐÁY MÀN HÌNH (MACRO)
;; ==========================================

; (defun my/notebook-init-macro ()
;   "Tự động kích hoạt Conda. Việc nạp Eglot và bảng lỗi sẽ tự chạy sau khi Conda xong."
;   (interactive)
  
;   ;; 1. Đưa file code phóng to 100% màn hình
;   (delete-other-windows)

;   ;; 2. Định nghĩa chuỗi hành động chạy THỰC SỰ TUẦN TỰ sau khi Conda kích hoạt xong
;   (let ((init-eglot-after-conda
;          (lambda ()
;            ;; Bật LSP từ môi trường mới
;            (eglot-ensure)
;            ;; Chờ một nhịp rất ngắn để cấu trúc giao diện ổn định rồi mở bảng lỗi
;            (with-current-buffer (current-buffer)
;              (flymake-show-buffer-diagnostics)
;              (other-window 1))
;            ;; Tự gỡ bỏ chính hàm này ra khỏi hook để không bị chạy lặp lại ở lần sau
;            (remove-hook 'conda-postactivate-hook init-eglot-after-conda))))
    
;     ;; Đăng ký hàm chờ sẵn ở cửa sau của Conda
;     (add-hook 'conda-postactivate-hook init-eglot-after-conda))

;   ;; 3. Bây giờ mới ra lệnh cho Conda chạy
;   (conda-env-activate "pydata-book"))

; ;; ĐĂNG KÝ LỆNH VIM :notebook
; (with-eval-after-load 'evil
;   (evil-ex-define-cmd "notebook" 'my/notebook-init-macro))
;; vv 
;;  v

;; Đã chuyển sang việc tự kích hoạt conda khi mở emacs và mở eglot thủ công bằng M-x eglot 
;; vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv 
;;      vvvvvvvvvvvvvvvvvvvvvvv
;;             vvvvvvv 
;;                v 
;; =============================================================================
;; TỰ ĐỘNG KÍCH HOẠT MÔI TRƯỜNG PYDATA-BOOK KHI KHỞI ĐỘNG EMACS
;; =============================================================================
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (fboundp 'conda-env-activate)
              ;; Chờ Emacs ổn định giao diện rồi kích hoạt môi trường ngầm
              (run-with-timer 0.5 nil
                              (lambda ()
                                (conda-env-activate "pyuet")
                                (message " [Conda] Đã tự động kích hoạt môi trường: pyuet"))))))






;; toggle line 
(defun my/toggle-comment-labeled-lines ()
  "Tự động comment hoặc uncomment bất kỳ dòng nào kết thúc bằng 'toggleline' (bỏ qua dấu #)."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((count 0))
      (while (not (eobp))
        (let ((line (buffer-substring-no-properties (line-beginning-position) (line-end-position))))
          (cond
           ;; Trường hợp 1: Dòng đang bị comment ở ĐẦU DÒNG và kết thúc bằng toggleline -> Tháo comment ở đầu
           ((string-match "^\\s-*#\\s-*\\(.*toggleline\\s-*\\)$" line)
            (delete-region (line-beginning-position) (line-end-position))
            (insert (match-string 1 line))
            (setq count (1+ count)))
           
           ;; Trường hợp 2: Dòng KHÔNG bị comment ở đầu dòng nhưng kết thúc bằng toggleline -> Thêm comment vào đầu
           ((string-match "^\\s-*\\([^#].*toggleline\\s-*\\)$" line)
            (delete-region (line-beginning-position) (line-end-position))
            (insert (concat "# " (match-string 1 line)))
            (setq count (1+ count)))))
        (forward-line 1))
      (message "Đã xử lý %d dòng chứa 'toggleline'" count))))

;; ĐĂNG KÝ PHÍM TẮT VIM: Nhấn dấu phẩy rồi bấm 'g' (,g) ở chế độ Normal Mode
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd ",g") 'my/toggle-comment-labeled-lines))


;; notebook send function to repl 
(with-eval-after-load 'evil
  (define-key evil-normal-state-map (kbd ",f") 'jupyter-eval-defun))


;; Nếu muốn vim hơn, có thể cài thêm evil collection 





;; =============================================================================
;; 1. Automatically intercept .ipynb files and load them into a separate .py file
;; =============================================================================
(defun my-open-ipynb-as-detached-py ()
  "Intercepts opening of .ipynb, extracts python contents into a clean .py buffer,
and kills the raw JSON buffer connection."
  (let* ((ipynb-path buffer-file-name)
         (py-path (concat (file-name-sans-extension ipynb-path) ".py"))
         (ipynb-buffer (current-buffer)))
    
    ;; Kill the raw JSON buffer after we read its contents
    (set-buffer-modified-p nil)
    (kill-buffer ipynb-buffer)
    
    ;; Open the target .py file. If it doesn't exist on disk, we populate it
    (find-file py-path)
    (when (not (file-exists-p py-path))
      ;; Insert the Jupytext-converted content into the new .py buffer
      (let ((converted-text (shell-command-to-string (format "jupytext --to py --output - %s" (shell-quote-argument ipynb-path)))))
        (insert converted-text)
        (goto-char (point-min))
        (set-buffer-modified-p t)))))

;; Bind this interceptor to any opened .ipynb files
(add-to-list 'auto-mode-alist '("\\.ipynb\\'" . my-open-ipynb-as-detached-py))


;; =============================================================================
;; 2. Create the custom Evil-mode Ex command (:cvnb)
;; =============================================================================
(evil-define-command evil-convert-to-notebook (&optional filename)
  "Convert the current Python script buffer into a .ipynb file via Jupytext.
If FILENAME is provided, saves there. Otherwise, replaces the .py extension with .ipynb."
  (interactive "<a>")
  (let* ((current-file (buffer-file-name))
         (target-ipynb
          (if (and filename (not (string-empty-p filename)))
              ;; If user specified a file path, ensure it ends with .ipynb
              (if (string-match-p "\\.ipynb\\'" filename) filename (concat filename ".ipynb"))
            ;; If no arg provided, use current file name swapping .py -> .ipynb
            (if current-file
                (concat (file-name-sans-extension current-file) ".ipynb")
              (error "Buffer is not visiting a file; please provide a path: :cvnb <path>")))))
    
    ;; We must pipe the buffer contents directly through jupytext to generate the output file
    (let ((coding-system-for-write 'utf-8))
      (write-region (point-min) (point-max) "/tmp/emacs-jupytext-tmp.py" nil 'silent))
    
    ;; Run jupytext terminal command to convert the file
    (let ((exit-code (call-process "jupytext" nil nil nil 
                                   "--to" "ipynb" 
                                   "-o" target-ipynb 
                                   "/tmp/emacs-jupytext-tmp.py")))
      (delete-file "/tmp/emacs-jupytext-tmp.py")
      (if (= exit-code 0)
          (message "Successfully exported notebook to: %s" target-ipynb)
        (error "Jupytext export failed. Make sure jupytext CLI tool is installed.")))))

;; Register the :cvnb command into Evil's Ex engine
(evil-ex-define-cmd "cvnb" 'evil-convert-to-notebook)

;; Bật redo để dùng được C-r vim 
(evil-set-undo-system 'undo-redo)


;; =============================================================================
;; CẤU HÌNH HIGHLIGHT TOÀN BỘ DÒNG TODO THEO PHONG CÁCH LAZYVIM (DRACULA THEME)
;; =============================================================================
(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode)
  :config
  ;; 1. Định nghĩa màu sắc tinh tế cho các TỪ KHÓA (Học tập LazyVim trên nền Dracula)
  ;; Không dùng foreground chói, dùng màu tối trên nền background nổi bật
  (setq hl-todo-keyword-faces
        '(("TODO"   . (:background "#ffb86c" :foreground "#282a36" :bold t)) ; Nền cam Dracula, chữ tối
          ("FIXME"  . (:background "#ff5555" :foreground "#f8f8f2" :bold t)) ; Nền đỏ dịu, chữ trắng
          ("BUG"    . (:background "#ff5555" :foreground "#f8f8f2" :bold t))
          ("NOTE"   . (:background "#8be9fd" :foreground "#282a36" :bold t)) ; Nền xanh cyan, chữ tối
          ("WARN"   . (:background "#f1fa8c" :foreground "#282a36" :bold t)))) ; Nền vàng, chữ tối

  ;; 2. BẬT HIGHLIGHT CHO TOÀN BỘ PHẦN CÒN LẠI CỦA DÒNG COMMENT
  ;; Thêm font-lock để tự động quét và "fill" màu nền nhẹ cho cả dòng phía sau từ khóa
  (defun my/hl-todo-entire-line-rgb ()
    (font-lock-add-keywords
     nil
     '(("\\s-*#\\s-*\\(TODO\\)\\(.*\\)$" 
        (1 'hl-todo t) 
        (2 '(:background "#44475a" :foreground "#ffb86c" :slant italic) t)) ; Nền xám Dracula, chữ cam nhạt
       ("\\s-*#\\s-*\\(FIXME\\|BUG\\)\\(.*\\)$" 
        (1 'hl-todo t) 
        (2 '(:background "#44475a" :foreground "#ff5555" :slant italic) t)) ; Nền xám Dracula, chữ đỏ nhạt
       ("\\s-*#\\s-*\\(NOTE\\)\\(.*\\)$" 
        (1 'hl-todo t) 
        (2 '(:background "#44475a" :foreground "#8be9fd" :slant italic) t))))) ; Nền xám Dracula, chữ cyan nhạt
  
  (add-hook 'python-mode-hook #'my/hl-todo-entire-line-rgb)

  ;; 3. BỘ PHÍM TẮT VIM (JUML CHUYỂN NHANH ]t VÀ [t)
  (with-eval-after-load 'evil
    (define-key evil-normal-state-map (kbd "]t") 'hl-todo-next)
    (define-key evil-normal-state-map (kbd "[t") 'hl-todo-previous)))
