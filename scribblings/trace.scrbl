#lang scribble/manual

@(require (for-label racket))

@title{Trace}

@defmodule[libgit2/include/trace]


@defproc[(git_trace_set
          [level _git_trace_level_t]
          [cb _git_trace_cb])
         integer?]{
 Sets the system tracing configuration to the specified level with the specified callback. When system events occur at a level equal to, or lower than, the given level they will be reported to the given callback.
}
