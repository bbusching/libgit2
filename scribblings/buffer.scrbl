#lang scribble/manual

@(require (for-label racket))

@title{Buffer}

@defmodule[libgit2/include/buffer]


@defproc[(git_buf_contains_nul
          [buf buf?])
         boolean?]{
 Check quickly if buffer contains a NUL byte

}

@defproc[(git_buf_free
          [buffer buf?])
         void?]{
 Free the memory referred to by the git_buf.

 Note that this does not free the git_buf itself, just the memory pointed to by buffer->ptr. This will not free the memory if it looks like it was not allocated internally, but it will clear the buffer back to the empty state.

}

@defproc[(git_buf_grow
          [buffer buf?]
          [target_size exact-positive-integer?])
         integer?]{
 Resize the buffer allocation to make more space.

 This will attempt to grow the buffer to accommodate the target size.

 If the buffer refers to memory that was not allocated by libgit2 (i.e. the asize field is zero), then ptr will be replaced with a newly allocated block of data. Be careful so that memory allocated by the caller is not lost. As a special variant, if you pass target_size as 0 and the memory is not allocated by libgit2, this will allocate a new buffer of size size and copy the external data into it.

 Currently, this will never shrink a buffer, only expand it.

 If the allocation fails, this will return an error and the buffer will be marked as invalid for future operations, invaliding the contents.

}

@defproc[(git_buf_is_binary
          [buf buf?])
         boolean?]{
 Check quickly if buffer looks like it contains binary data

}

@defproc[(git_buf_set
          [buffer buf?]
          [data bytes?]
          [datalen exact-positive-integer?])
         integer?]{
 Set buffer to a copy of some raw data.
}
