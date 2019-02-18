#lang scribble/manual

@(require (for-label racket))

@title{Blob}

@defmodule[libgit2/include/blob]


@defproc[(git_blob_create_frombuffer
         [id oid?]
         [repo repository?]
         [buffer (_cpointer _void)]
         [len integer?])
         integer?]{
Write an in-memory buffer to the ODB as a blob

}

@defproc[(git_blob_create_fromdisk
          [id oid?]
          [repo repository?]
          [path string?])
         integer?]{
 Read a file from the filesystem and write its content to the Object Database as a loose blob

}

@defproc[(git_blob_create_fromstream
          [repo repository?]
          [hintpath string?])
         writestream?]{
 Create a stream to write a new blob into the object db

 This function may need to buffer the data on disk and will in general not be the right choice if you know the size of the data to write. If you have data in memory, use git_blob_create_frombuffer(). If you do not, but know the size of the contents (and don't want/need to perform filtering), use git_odb_open_wstream().

 Don't close this stream yourself but pass it to git_blob_create_fromstream_commit() to commit the write to the object db and get the object id.

 If the hintpath parameter is filled, it will be used to determine what git filters should be applied to the object before it is written to the object database.

}

@defproc[(git_blob_create_fromstream_commit
          [out oid?]
          [stream writestream?])
         integer?]{
 Close the stream and write the blob to the object db

 The stream will be closed and freed.

}

@defproc[(git_blob_create_fromworkdir
          [id oid?]
          [repo repository?]
          [relative_path string?])
         integer?]{
 Read a file from the working folder of a repository and write it to the Object Database as a loose blob

}

@defproc[(git_blob_dup
          [source blob?])
         blob?]{
 Create an in-memory copy of a blob. The copy must be explicitly free'd or it will leak.

}

@defproc[(git_blob_filtered_content
          [out buf?]
          [blob blob?]
          [as_path string?]
          [check_for_binary_data boolean?])
         integer?]{
 Get a buffer with the filtered content of a blob.

 This applies filters as if the blob was being checked out to the working directory under the specified filename. This may apply CRLF filtering or other types of changes depending on the file attributes set for the blob and the content detected in it.

 The output is written into a git_buf which the caller must free when done (via git_buf_free).

 If no filters need to be applied, then the out buffer will just be populated with a pointer to the raw content of the blob. In that case, be careful to not free the blob until done with the buffer or copy it into memory you own.

}

@defproc[(git_blob_free
          [blob blob?])
         void?]{
 Close an open blob

 This is a wrapper around git_object_free()

 IMPORTANT: It is necessary to call this method when you stop using a blob. Failure to do so will cause a memory leak.

}

@defproc[(git_blob_id
          [blob blob?])
         oid?]{
 Get the id of a blob.

}

@defproc[(git_blob_is_binary
          [blob blob?])
         boolean?]{
 Determine if the blob content is most certainly binary or not.

 The heuristic used to guess if a file is binary is taken from core git: Searching for NUL bytes and looking for a reasonable ratio of printable to non-printable characters among the first 8000 bytes.

}

@defproc[(git_blob_lookup
          [repo repository?]
          [id oid?])
         blob?]{
 Lookup a blob object from a repository.

}

@defproc[(git_blob_lookup_prefix
          [repo repository?]
          [id oid?]
          [len size_t])
         blob?]{
 Lookup a blob object from a repository, given a prefix of its identifier (short id).

}

@defproc[(git_blob_owner
          [blob blob?])
         repository?]{
 Get the repository that contains the blob.

}

@defproc[(git_blob_rawcontent
          [blob blob?])
         bytes?]{
 Get a read-only buffer with the raw content of a blob.

 A pointer to the raw content of a blob is returned; this pointer is owned internally by the object and shall not be free'd. The pointer may be invalidated at a later time.

}

@defproc[(git_blob_rawsize
          [blob blob?])
         git_off_t?]{
 Get the size in bytes of the contents of a blob
}
