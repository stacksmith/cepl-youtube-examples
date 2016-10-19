;;;; 
;;;; from youtube.com video 1-CEPL: Lisp, Textures and Shaders
;;;;
;;;; step1 - starting point, similar to what's on youtube.
;;;;

;;(ql:quickload :cepl.sdl2)(ql:quickload :cepl.examples)(in-package cepl.examples)(cepl:repl)
(in-package #:cepl.examples)
(defparameter *running* nil)

;; *quad* is a list compatible with g-pt format (vec-3 pos and a vec-2 tex)
(defparameter *quad* (list (list (v! -0.5  0.5 0.0 1.0) (v! 0.0 0.0))
			   (list (v! -0.5 -0.5 0.0 1.0) (v! 0.0 1.0))
			   (list (v!  0.5 -0.5 0.0 1.0) (v! 1.0 1.0))
			   (list (v! -0.5  0.5 0.0 1.0) (v! 0.0 0.0))
			   (list (v!  0.5 -0.5 0.0 1.0) (v! 1.0 1.0))
			   (list (v!  0.5  0.5 0.0 1.0) (v! 1.0 0.0))))

(defparameter *vert-array* nil)
(defparameter *vert-stream* nil)

(defun-g vert ((vert g-pt))
  (v! (pos vert) 1))

(defun-g frag ()
  (v! 0 0 1 0))

(def-g-> prog-1 ()
  vert frag)

(defun step-demo ()
  (step-host)        ;; Advance the host environment frame
  (update-repl-link) ;; Keep the REPL responsive while running
  (clear)            ;; Clear the drawing buffer 
  (map-g #'prog-1 *vert-stream*) ;; Render data from GPU datastream
  (swap))            ;; Display newly rendered buffer 


(defun run-loop ()
  (setf *running* t
	;; Create a gpu array from our Lisp vertex data
        *vert-array* (make-gpu-array *quad* :dimensions 6
				     :element-type 'g-pt)
	;; Create a GPU datastream
	*vert-stream* (make-buffer-stream *vert-array*))
  ;; continue rendering frames until *running* is set to nil
  (loop :while (and  *running*
		     (not (shutting-down-p))) :do
     (continuable (step-demo))))

(defun stop-loop ()
  (setf *running* nil))

