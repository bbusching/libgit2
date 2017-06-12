#lang scribble/manual

@(require (for-label racket))

@title{Object Database}

@defmodule[libgit2/include/odb]


@defproc[(git_odb_add_alternate
          [odb odb?]
          [backend odb_backend?]
          [priority integer?])
         integer?]{
 Add a custom backend to an existing Object DB; this backend will work as an alternate.

 Alternate backends are always checked for objects after all the main backends have been exhausted.

 The backends are checked in relative ordering, based on the value of the priority parameter.

 Writing is disabled on alternate backends.

 Read for more information.

}

@defproc[(git_odb_add_backend
          [odb odb?]
          [backend odb_backend?]
          [priority integer?])
         integer?]{
 Add a custom backend to an existing Object DB

 The backends are checked in relative ordering, based on the value of the priority parameter.

 Read for more information.

}

@defproc[(git_odb_add_disk_alternate
          [odb odb?]
          [path string?])
         integer?]{
 Add an on-disk alternate to an existing Object DB.

 Note that the added path must point to an objects, not to a full repository, to use it as an alternate store.

 Alternate backends are always checked for objects after all the main backends have been exhausted.

 Writing is disabled on alternate backends.

}

@defproc[(git_odb_backend_loose
          [objects_dir string?]
          [compression_level integer?]
          [do_fsync boolean?]
          [dir_mode exact-positive-integer?]
          [file_mode exact-positive-integer?])
         odb_backend?]{
 Create a backend for loose objects

}

@defproc[(git_odb_backend_one_pack
          [index_file string?])
         odb_backend?]{
 Create a backend out of a single packfile

 This can be useful for inspecting the contents of a single packfile.

}

@defproc[(git_odb_backend_pack
          [objects_dir string?])
         odb_backend?]{
 Create a backend for the packfiles.

}

@defproc[(git_odb_exists
          [db odb?]
          [id oid?])
         boolean?]{
 Determine if the given object can be found in the object database.

}

@defproc[(git_odb_exists_prefix
          [out oid?]
          [db odb?]
          [short_id oid?]
          [len integer?])
         boolean?]{
 Determine if an object can be found in the object database by an abbreviated object ID.

}

@defproc[(git_odb_expand_ids
          [db odb?]
          [ids git_odb_expand_id?]
          [count integer?])
         integer?]{
 Determine if one or more objects can be found in the object database by their abbreviated object ID and type. The given array will be updated in place: for each abbreviated ID that is unique in the database, and of the given type (if specified), the full object ID, object ID length (GIT_OID_HEXSZ) and type will be written back to the array. For IDs that are not found (or are ambiguous), the array entry will be zeroed.

 Note that since this function operates on multiple objects, the underlying database will not be asked to be reloaded if an object is not found (which is unlike other object database operations.)

}

@defproc[(git_odb_foreach
          [db odb?]
          [cb git_odb_foreach_cb]
          [payload bytes?])
         integer?]{
 List all objects available in the database

 The callback will be called for each object available in the database. Note that the objects are likely to be returned in the index order, which would make accessing the objects in that order inefficient. Return a non-zero value from the callback to stop looping.

}

@defproc[(git_odb_free
          [db odb?])
         void?]{
 Close an open object database.

}

@defproc[(git_odb_get_backend
          [odb odb?]
          [pos integer?])
         odb_backend?]{
 Lookup an ODB backend object by index

}

@defproc[(git_odb_hash
          [out oid?]
          [data bytes?]
          [len integer?]
          [type _git_otype])
         integer?]{
 Determine the object-ID (sha1 hash) of a data buffer

 The resulting SHA-1 OID will be the identifier for the data buffer as if the data buffer it were to written to the ODB.

}

@defproc[(git_odb_hashfile
          [out oid?]
          [path string?]
          [type _git_otype])
         integer?]{
 Read a file from disk and fill a git_oid with the object id that the file would have if it were written to the Object Database as an object of the given type (w/o applying filters). Similar functionality to git.git's git hash-object without the -w flag, however, with the --no-filters flag. If you need filters, see git_repository_hashfile.

}

@defproc[(git_odb_init_backend
          [backend odb_backend?]
          [int unsigned])
         integer?]{
 Initializes a git_odb_backend with default values. Equivalent to creating an instance with GIT_ODB_BACKEND_INIT.

}

@defproc[(git_odb_new)
         odb?]{
 Create a new object database with no backends.

 Before the ODB can be used for read/writing, a custom database backend must be manually added using git_odb_add_backend()

}

@defproc[(git_odb_num_backends
          [odb odb?])
         integer?]{
 Get the number of ODB backend objects

}

@defproc[(git_odb_object_data
          [object odb_object?])
         bytes?]{
 Return the data of an ODB object

 This is the uncompressed, raw data as read from the ODB, without the leading header.

 This pointer is owned by the object and shall not be free'd.

}

@defproc[(git_odb_object_dup
          [source odb_object?])
         odb_object?]{
 Create a copy of an odb_object

 The returned copy must be manually freed with git_odb_object_free. Note that because of an implementation detail, the returned copy will be the same pointer as source: the object is internally refcounted, so the copy still needs to be freed twice.

}

@defproc[(git_odb_object_free
          [object odb_object?])
         void?]{
 Close an ODB object

 This method must always be called once a git_odb_object is no longer needed, otherwise memory will leak.

}

@defproc[(git_odb_object_id
          [object odb_object?])
         oid?]{
 Return the OID of an ODB object

 This is the OID from which the object was read from

}

@defproc[(git_odb_object_size
          [object odb_object?])
         integer?]{
 Return the size of an ODB object

 This is the real size of the data buffer, not the actual size of the object.

}

@defproc[(git_odb_object_type
          [object odb_object?])
         _git_otype]{
 Return the type of an ODB object

}

@defproc[(git_odb_open
          [objects_dir string?])
         odb?]{
 Create a new object database and automatically add the two default backends:

 - git_odb_backend_loose: read and write loose object files      from disk, assuming `objects_dir` as the Objects folder

 - git_odb_backend_pack: read objects from packfiles,        assuming `objects_dir` as the Objects folder which      contains a 'pack/' folder with the corresponding data
}

@defproc[(git_odb_open_rstream
          [db odb?]
          [oid oid?])
         odb_stream?]{
 Open a stream to read an object from the ODB

 Note that most backends do not support streaming reads because they store their objects as compressed/delta'ed blobs.

 It's recommended to use git_odb_read instead, which is assured to work on all backends.

 The returned stream will be of type GIT_STREAM_RDONLY and will have the following methods:

 - stream->read: read `n` bytes from the stream      - stream->free: free the stream
 The stream must always be free'd or will leak memory.

}

@defproc[(git_odb_open_wstream
          [db odb?]
          [size _git_off_t]
          [type _git_otype])
         odb_stream?]{
 Open a stream to write an object into the ODB

 The type and final length of the object must be specified when opening the stream.

 The returned stream will be of type GIT_STREAM_WRONLY, and it won't be effective until git_odb_stream_finalize_write is called and returns without an error

 The stream must always be freed when done with git_odb_stream_free or will leak memory.

}

@defproc[(git_odb_read
          [db odb?]
          [id oid?])
         odb_object?]{
 Read an object from the database.

 This method queries all available ODB backends trying to read the given OID.

 The returned object is reference counted and internally cached, so it should be closed by the user once it's no longer in use.

}

@defproc[(git_odb_read_header
          [len_out (_cpoiner _size)]
          [type_out (_cpointer _git_otype)]
          [db odb?]
          [id oid?])
         integer?]{
 Read the header of an object from the database, without reading its full contents.

 The header includes the length and the type of an object.

 Note that most backends do not support reading only the header of an object, so the whole object will be read and then the header will be returned.

}

@defproc[(git_odb_read_prefix
          [db odb?]
          [short_id oid?]
          [len integer?])
         odb_object?]{
 Read an object from the database, given a prefix of its identifier.

 This method queries all available ODB backends trying to match the 'len' first hexadecimal characters of the 'short_id'. The remaining (GIT_OID_HEXSZ-len)*4 bits of 'short_id' must be 0s. 'len' must be at least GIT_OID_MINPREFIXLEN, and the prefix must be long enough to identify a unique object in all the backends; the method will fail otherwise.

 The returned object is reference counted and internally cached, so it should be closed by the user once it's no longer in use.

}

@defproc[(git_odb_refresh
          [db odb?])
         integer?]{
 Refresh the object database to load newly added files.

 If the object databases have changed on disk while the library is running, this function will force a reload of the underlying indexes.

 Use this function when you're confident that an external application has tampered with the ODB.

 NOTE that it is not necessary to call this function at all. The library will automatically attempt to refresh the ODB when a lookup fails, to see if the looked up object exists on disk but hasn't been loaded yet.

}

@defproc[(git_odb_stream_finalize_write
          [out oid?]
          [stream odb_stream?])
         integer?]{
 Finish writing to an odb stream

 The object will take its final name and will be available to the odb.

 This method will fail if the total number of received bytes differs from the size declared with git_odb_open_wstream()

}

@defproc[(git_odb_stream_free
          [stream odb_stream?])
         void?]{
 Free an odb stream

}

@defproc[(git_odb_stream_read
          [stream odb_stream?]
          [buffer bytes?]
          [len integer?])
         integer?]{
 Read from an odb stream

 Most backends don't implement streaming reads

}

@defproc[(git_odb_stream_write
          [stream odb_stream?]
          [buffer string?]
          [len size_t])
         integer?]{
 Write to an odb stream

 This method will fail if the total number of received bytes exceeds the size declared with git_odb_open_wstream()

}

@defproc[(git_odb_write
          [out oid?]
          [odb odb?]
          [data bytes?]
          [len integer?]
          [type _git_otype])
         integer?]{
 Write an object directly into the ODB

 This method writes a full object straight into the ODB. For most cases, it is preferred to write objects through a write stream, which is both faster and less memory intensive, specially for big objects.

 This method is provided for compatibility with custom backends which are not able to support streaming writes

}

@defproc[(git_odb_write_pack
          [db odb?]
          [progress_cb git_transfer_progress_cb]
          [progress_payload bytes?])
         odb_writepack?]{
 Open a stream for writing a pack file to the ODB.

 If the ODB layer understands pack files, then the given packfile will likely be streamed directly to disk (and a corresponding index created). If the ODB layer does not understand pack files, the objects will be stored in whatever format the ODB layer uses.
}
