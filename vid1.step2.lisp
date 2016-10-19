;;;; 
;;;; from youtube.com video 1-CEPL: Lisp, Textures and Shaders
;;;;
;;;; step2 - added texture support
;;;;

;;(ql:quickload :cepl.sdl2)(ql:quickload :cepl.examples)(in-package cepl.examples)(cepl:repl)

(in-package #:cepl.examples)
(defparameter *running* nil)
;; *quad* is a list compatible with g-pt format (vec-3 pos and a vec-2 tex)
(defparameter *quad* (list (list (v! -0.5  0.5 0.0) (v! 0.0 0.0))
			   (list (v! -0.5 -0.5 0.0) (v! 0.0 1.0))
			   (list (v!  0.5 -0.5 0.0) (v! 1.0 1.0))
			   (list (v! -0.5  0.5 0.0) (v! 0.0 0.0))
			   (list (v!  0.5 -0.5 0.0) (v! 1.0 1.0))
			   (list (v!  0.5  0.5 0.0) (v! 1.0 0.0))))

(defparameter *vert-array* nil)  ;will be filled with a g-pt array
(defparameter *vert-stream* nil) ;buffer-stream from *vert-array*

(defparameter *tex-array* nil)   ;will be filled with a 64x64 random uint8 array
(defparameter *texture* nil)     ;texture from *tex-array*
(defparameter *sampler* nil)     ;sampled texture


(defun-g vert ((vert g-pt) )
  (values (v! (pos vert) 1)
	  (:smooth (tex vert)))) ;passed to fragment shader

(defun-g frag ((tex-coord :vec2) &uniform (texture :sampler-2d))
  (texture texture tex-coord))

(def-g-> prog-1 ()
  vert frag)


(defun step-demo ()
  (step-host)        ;; Advance the host environment frame
  (update-repl-link) ;; Keep the REPL responsive while running
  (clear)            ;; Clear the drawing buffer 
  (map-g #'prog-1 *vert-stream* :texture *sampler*) ;;pass verts and uniform
  (swap))            ;; Display newly rendered buffer 


(defun run-loop ()
  (with-viewport (make-viewport '(240 240)) ;for larger viewports must resize window...
    (setf *running* t
	  ;; Create a gpu array from our Lisp vertex data
	  *vert-array* (make-gpu-array *quad* :dimensions 6
				       :element-type 'g-pt)
	  ;; Create a GPU datastream
	  *vert-stream* (make-buffer-stream *vert-array*)

	  *tex-array* (make-c-array (loop for x below 64 collect
					 (loop for y below 64 collect
					      (random 254)))
				    :dimensions '(64 64)
				    :element-type :uint8)
	  *texture* (make-texture *tex-array*)
	  *sampler* (sample *texture*))
    ;; continue rendering frames until *running* is set to nil
    (loop :while (and  *running*
		       (not (shutting-down-p))) :do
       (continuable (step-demo)))))

(defun stop-loop ()
  (setf *running* nil))



