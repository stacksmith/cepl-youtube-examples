October 18, 2016

# vid1.step1.lisp
First of all, let's get to the starting point of the video and load the code to display a blue rectangle.

In Emacs, open "vid1.step1.lisp", and compile it with `C-c C-k`.

Comparing your source to the video you will note a few discrepancies.

- The demo is executed with `run-loop` and stopped with `stop-loop`, like all other demos.  `*running*` is used to track the current state - when `nil` the demo terminates.
- `*quad*` is initialized with 3D vectors, in compliance with [g-pt format](http://techsnuffle.com/cepl/api.html#CEPL.TYPES.PREDEFINED:G-PT).
- `vert-data` struct is no longer needed, as the data is in `g-pt` format.
- `defpipeline` is obsolete.  Separate shaders and `def-g` follow.
- `vert` shader takes a `g-pt` parameter.  The first (and only) value it returns is used by GL as the position.  As GL requires a 4D vector and `(pos vert)` provides 3 components, the forth one is set to 1 here.
- `frag` shader here takes no parameters.  It simply outputs blue, as blue is the third component of the RGBA vector.
- `def-g` creates the GPU pipeline.
- `step-demo` looks a little different; the comments are self-explanatory.
- `run-loop` is also modernized.  Note that `:element-type` is now `'g-pt`.
- Note that the syntax for [make-c-array](http://techsnuffle.com/cepl/api.html#CEPL.C-ARRAYS:MAKE-C-ARRAY) and [make-gpu-array](http://techsnuffle.com/cepl/api.html#CEPL.GPU-ARRAYS.BUFFER-BACKED:MAKE-GPU-ARRAY) has changed - the first parameter is the data.

At this point you should be able to see the blue rectangle in the CEPL output window.

# vid1.step2.lisp

- In addition to `*tex-array*` and `*texture*` defparameters, you will note one for `*sampler*`
- The video describes how to initialize the texture in the REPL.  The code is inside run-loop.
- The `vert` shader now returns two values.  The first one is consumed by GL, and the second one is passed on to the next stage in the pipeline, the `frag` shader.  This second value now looks like `(:smooth (tex vert))` instead of the gobbledegoo in the video.
- The `frag` shader now takes parameters: data from the previous stage, and a uniform sampled texture.  Note that we now return the color using the `texture` function that operates on the parameters named `texture` and `tex-coord`.
- The `map-g` function now passes the sampled texture to the pipeline.  CEPL is smart enough to figure out what to do with it.
- `run-loop` initialization looks a little different from the video to match current reality.

You should now see a bumpy red rectangle.


