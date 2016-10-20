(in-package :cepl.examples)

;; 
(defparameter *lisp-data* (list (list (v!  0.5 -0.36 0) (v! 0 1 0 1))
				(list (v!    0   0.5 0) (v! 1 0 0 1))
				(list (v! -0.5 -0.36 0) (v! 0 0 1 1))))
(defparameter *array* nil)  
(defparameter *stream* nil)
(defparameter *running* nil)
(defparameter *loop-pos* 0) 


(defun-g tri-vert ((vert g-pc) &uniform (offset :vec2))
  (values (+ (v! offset 0 0)
	     (v! (pos vert) 1)) ;; [1]
          (col vert)))

(defun-g tri-frag ((color :vec4))
  color)

(def-g-> prog-1 ()
  tri-vert tri-frag)

(defun step-demo ()
  (incf *loop-pos* 0.0001) 
  (step-host)
  (update-repl-link)
  (clear)
  (map-g #'prog-1 *stream* :offset (v! (sin *loop-pos*)
				       (cos *loop-pos*)))
  (swap))

(defun run-loop ()
       (setf *running* t
	     *array* (make-gpu-array *lisp-data* :element-type 'g-pc)
	     *stream* (make-buffer-stream *array*))
       (loop :while (and *running* (not (shutting-down-p))) :do
	  (continuable (step-demo))))

(defun stop-loop ()
  (setf *running* nil))
