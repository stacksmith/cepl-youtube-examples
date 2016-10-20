October 19, 2016

[Notes](vid0.md) for video [0 - CEPL: Lispy OpenGL](https://www.youtube.com/watch?v=a2tTpjGOhjw)

# vid0.step1.lisp

In Emacs, open "vid0.step1.lisp", and compile it with `C-c C-k`.

Comparing your source to the video you will note a few discrepancies.

1. `vert-data` structure eliminated. CEPL now provides a convenient [g-pc](http://techsnuffle.com/cepl/api.html#CEPL.TYPES.PREDEFINED:G-PC) type, with position and color.
2. Parameters are slightly different for modern CEPL.
3. Vertex shader is defined separately with [defun-g](http://techsnuffle.com/cepl/api.html#CEPL.PIPELINES:DEFUN-G).  It returns two values: one, positional, is consumed by the GPU.  The second, the color component, is passed on down the pipeline.
4. Fragment shader receives the color from the previous shader, and simply returns it.  Acytually, it interpolates the colors automatically.
5. The pipeline definition with [def-g->](http://techsnuffle.com/cepl/api.html#CEPL.PIPELINES:DEF-G-%3E), composing the two shaders into our pipeline.
6. Replaces "draw".  This is boilerplate housekeeping. [map-g](http://techsnuffle.com/cepl/api.html#CEPL.PIPELINES:MAP-G) macro passes the data into the pipeline.
7. Note how arrays are initialized.  The rest is boilerplate.

# vid0.step2.lisp

Making the triangle move in a circle

Very little has changed here.

1. The addition looks a little different since we are converting the position vector to a 4D vector in the first place.

# vid0.step3.lisp

20 little triangles moving in a circle.  The video explains it all.
