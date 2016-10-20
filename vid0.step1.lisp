(in-package :cepl.examples)

;; [1]
(defparameter *lisp-data* (list (list (v!  0.5 -0.36 0) (v! 0 1 0 1))
				(list (v!    0   0.5 0) (v! 1 0 0 1))
				(list (v! -0.5 -0.36 0) (v! 0 0 1 1))))
(defparameter *array* nil)  ;; [2]
(defparameter *stream* nil)
(defparameter *running* nil)


(defun-g tri-vert ((vert g-pc)) ;; [3]
  (values (v! (pos vert) 1.0) 
          (col vert)))

(defun-g tri-frag ((color :vec4)) ;; [4]
  color)

(def-g-> prog-1 () ;; [5]
  tri-vert tri-frag)

(defun step-demo () ;; [6]
  (step-host)
  (update-repl-link)
  (clear)
  (map-g #'prog-1 *stream*)
  (swap))

(defun run-loop () ;;[7]
       (setf *running* t
	     *array* (make-gpu-array *lisp-data* :element-type 'g-pc)
	     *stream* (make-buffer-stream *array*))
       (loop :while (and *running* (not (shutting-down-p))) :do
	  (continuable (step-demo))))

(defun stop-loop ()
  (setf *running* nil))
