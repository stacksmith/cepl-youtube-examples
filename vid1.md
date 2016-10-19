October 18, 2016

First of all, let's get to the starting point of the video and load the code to display a red rectangle.

- Load the REPL
- (ql:quickload :cepl.sdl2)
- (cepl:repl)
- (ql:quickload :cepl.examples)
- (in-package :cepl.examples)

In Emacs, open "vid1.step1.lisp", and compile it with C-c C-k.

Comparing your source to the video you will note a few discrepancies.

- The demo is executed with `run-loop` and stopped with `stop-loop`, like all other demos.  *running* is used to track the current state - when nil the demo terminates.
- *quad* is initialized with 3D vectors, in compliance with [g-pt format](http://techsnuffle.com/cepl/api.html#CEPL.TYPES.PREDEFINED:G-PT).
- vert-data struct is no longer needed, as the data is in g-pt format.
- defpipeline is obsolete.  Separate shaders and `def-g` follow.
- vert shader takes a g-pt parameter.  The first (and only) value it returns is used by GL as the position.  As GL requires a 4D vector and (pos vert) provides 3 components, the forth one is set to 1 here.
- frag shader here takes no parameters.  It simply outputs blue, as blue is the third component of the RGBA vector.
- `def-g` creates the GPU pipeline.
- `step-demo` looks a little different; the comments are self-explanatory.
- `run-loop` is also modernized.  Note that `:element-type` is now `'g-pt`.





