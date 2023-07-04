#lang scribble/manual

@(require (for-label racket))

@title{Note}

@defmodule[libgit2/include/note]


@defproc[(git_note_author
          [note note?])
         signature?]{
 Get the note author

}

@defproc[(git_note_committer
          [note note?])
         signature?]{
 Get the note committer

}

@defproc[(git_note_create
          [out oid?]
          [repo repository?]
          [notes_ref (or/c string? #f)]
          [author signature?]
          [committer signature?]
          [oid oid?]
          [note string?]
          [force boolean?])
         integer?]{
 Add a note for an object

}

@defproc[(git_note_foreach
          [repo repository?]
          [notes_ref string?]
          [note_cb git_note_foreach_cb]
          [payload bytes?])
         integer?]{
 Loop over all the notes within a specified namespace and issue a callback for each one.

}

@defproc[(git_note_free
          [note note?])
         void?]{
 Free a git_note object

}

@defproc[(git_note_id
          [note note?])
         oid?]{
 Get the note object's id

}

@defproc[(git_note_iterator_free
          [it note_iterator?])
         void?]{
 Frees an git_note_iterator

}

@defproc[(git_note_iterator_new
          [repo repository?]
          [notes_ref string?])
         note_iterator?]{
 Creates a new iterator for notes

 The iterator must be freed manually by the user.

}

@defproc[(git_note_message
          [note note?])
         string?]{
 Get the note message

}

@defproc[(git_note_next
          [note_id oid?]
          [annotated_id oid?]
          [it note_iterator?])
         integer?]{
 Return the current item (note_id and annotated_id) and advance the iterator internally to the next value

}

@defproc[(git_note_read
          [repo repository?]
          [notes_ref (or/c string? #f)]
          [oid oid?])
         note?]{
 Read the note for an object

 The note must be freed manually by the user.

}

@defproc[(git_note_remove
          [repo repository?]
          [notes_ref (or/c string? #f)]
          [author signature?]
          [committer signature?]
          [oid oid?])
         integer?]{
 Remove the note for an object
}
