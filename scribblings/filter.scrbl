#lang scribble/manual

@(require (for-label racket))

@title{Filter}

@defmodule[libgit2/include/filter]


@defproc[(git_filter_list_apply_to_blob
          [out buf?]
          [filters filter_list?]
          [blob blob?])
         integer?]{
 Apply a filter list to the contents of a blob

}

@defproc[(git_filter_list_apply_to_data
          [out buf?]
          [filters filter_list?]
          [in buf?])
         integer?]{
 Apply filter list to a data buffer.

 If the in buffer holds data allocated by libgit2 (i.e. in->asize is not zero), then it will be overwritten when applying the filters. If not, then it will be left untouched.

 If there are no filters to apply (or filters is NULL), then the out buffer will reference the in buffer data (with asize set to zero) instead of allocating data. This keeps allocations to a minimum, but it means you have to be careful about freeing the in data since out may be pointing to it!

}

@defproc[(git_filter_list_apply_to_file
          [out buf?]
          [filters filter_list?]
          [repo repository?]
          [path string?])
         integer?]{
 Apply a filter list to the contents of a file on disk

 'path' is relative to wrokdir
}

@defproc[(git_filter_list_contains
          [filters filter_list?]
          [name string?])
         boolean?]{
 Query the filter list to see if a given filter (by name) will run. The built-in filters "crlf" and "ident" can be queried, otherwise this is the name of the filter specified by the filter attribute.

 This will return 0 if the given filter is not in the list, or 1 if the filter will be applied.

}

@defproc[(git_filter_list_free
          [filters filter_list?])
         void?]{
 Free a git_filter_list

}

@defproc[(git_filter_list_length
          [fl filter_list?])
         integer?]{
 Look up how many filters are in the list

 We will attempt to apply all of these filters to any data passed in, but note that the filter apply action still has the option of skipping data that is passed in (for example, the CRLF filter will skip data that appears to be binary).

}

@defproc[(git_filter_list_load
          [repo repository?]
          [blob blob?]
          [path string?]
          [mode _git_filter_mode_t]
          [flags _git_filter_flag_t])
         (or/c filter_list? #f)]{
 Load the filter list for a given path.

 This will return 0 (success) but set the output git_filter_list to NULL if no filters are requested for the given file.

}

@defproc[(git_filter_list_new
          [repo repository?]
          [mode _git_filter_mode_t]
          [options _git_filter_flag_t])
         filter_list?]{
 Create a new empty filter list

 Normally you won't use this because git_filter_list_load will create the filter list for you, but you can use this in combination with the git_filter_lookup and git_filter_list_push functions to assemble your own chains of filters.

}

@defproc[(git_filter_list_push
          [fl filter_list?]
          [filter filter?]
          [payload bytes?])
         integer?]{
 Add a filter to a filter list with the given payload.

 Normally you won't have to do this because the filter list is created by calling the "check" function on registered filters when the filter attributes are set, but this does allow more direct manipulation of filter lists when desired.

 Note that normally the "check" function can set up a payload for the filter. Using this function, you can either pass in a payload if you know the expected payload format, or you can pass NULL. Some filters may fail with a NULL payload. Good luck!

}

@defproc[(git_filter_list_stream_blob
          [filters filter_list?]
          [blob blob?]
          [target writestream?])
         integer?]{
 Apply a filter list to a blob as a stream

}

@defproc[(git_filter_list_stream_data
          [filters filter_list?]
          [data buf?]
          [target writestream?])
         integer?]{
 Apply a filter list to an arbitrary buffer as a stream

}

@defproc[(git_filter_list_stream_file
          [filters filter_list?]
          [repo repository?]
          [path string?]
          [target writestream?])
         integer?]{
 Apply a filter list to a file as a stream

}

@defproc[(git_filter_lookup
          [name string?])
         integer?]{
 Look up a filter by name

}

@defproc[(git_filter_register
          [name string?]
          [filter filter?]
          [priority integer?])
         integer?]{
 Register a filter under a given name with a given priority.

 As mentioned elsewhere, the initialize callback will not be invoked immediately. It is deferred until the filter is used in some way.

 A filter's attribute checks and check and apply callbacks will be issued in order of priority on smudge (to workdir), and in reverse order of priority on clean (to odb).

 Two filters are preregistered with libgit2: - GIT_FILTER_CRLF with priority 0 - GIT_FILTER_IDENT with priority 100

 Currently the filter registry is not thread safe, so any registering or deregistering of filters must be done outside of any possible usage of the filters (i.e. during application setup or shutdown).

}

@defproc[(git_filter_source_filemode
          [src filter_source?])
         integer?]{
 Get the file mode of the source file If the mode is unknown, this will return 0

}

@defproc[(git_filter_source_flags
          [src filter_source?])
         integer?]{
 Get the combination git_filter_flag_t options to be applied

}

@defproc[(git_filter_source_id
          [src filter_source?])
         oid?]{
 Get the OID of the source If the OID is unknown (often the case with GIT_FILTER_CLEAN) then this will return NULL.

}

@defproc[(git_filter_source_mode
          [src filter_source?])
         _git_filter_mode_t]{
 Get the git_filter_mode_t to be used

}

@defproc[(git_filter_source_path
          [src filter_source?])
         string?]{
 Get the path that the source data is coming from.

}

@defproc[(git_filter_source_repo
          [src filter_source?])
         repository?]{
 Get the repository that the source data is coming from.

}

@defproc[(git_filter_unregister
          [name string?])
         integer?]{
 Remove the filter with the given name

 Attempting to remove the builtin libgit2 filters is not permitted and will return an error.

 Currently the filter registry is not thread safe, so any registering or deregistering of filters must be done outside of any possible usage of the filters (i.e. during application setup or shutdown).
}
