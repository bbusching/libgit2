#lang scribble/manual

@(require (for-label racket))

@title{Status}

@defmodule[libgit2/include/status]


@defproc[(git_status_byindex
          [statuslist status_list?]
          [idx integer?])
         git_status_entry?]{
 Get a pointer to one of the entries in the status list.

 The entry is not modifiable and should not be freed.

}

@defproc[(git_status_file
          [repo repository?]
          [path string?])
         _git_status_t]{
 Get file status for a single file.

 This tries to get status for the filename that you give. If no files match that name (in either the HEAD, index, or working directory), this returns GIT_ENOTFOUND.

 If the name matches multiple files (for example, if the path names a directory or if running on a case- insensitive filesystem and yet the HEAD has two entries that both match the path), then this returns GIT_EAMBIGUOUS because it cannot give correct results.

 This does not do any sort of rename detection. Renames require a set of targets and because of the path filtering, there is not enough information to check renames correctly. To check file status with rename detection, there is no choice but to do a full git_status_list_new and scan through looking for the path that you are interested in.

}

@defproc[(git_status_foreach
          [repo repository?]
          [callback _git_status_cb]
          [payload bytes?])
         integer?]{
 Gather file statuses and run a callback for each one.

 The callback is passed the path of the file, the status (a combination of the git_status_t values above) and the payload data pointer passed into this function.

 If the callback returns a non-zero value, this function will stop looping and return that value to caller.

}

@defproc[(git_status_foreach_ext
          [repo repository?]
          [opts git_status_opts?]
          [callback _git_status_cb]
          [payload bytes?])
         integer?]{
 Gather file status information and run callbacks as requested.

 This is an extended version of the git_status_foreach() API that allows for more granular control over which paths will be processed and in what order. See the git_status_options structure for details about the additional controls that this makes available.

 Note that if a pathspec is given in the git_status_options to filter the status, then the results from rename detection (if you enable it) may not be accurate. To do rename detection properly, this must be called with no pathspec so that all files can be considered.

}

@defproc[(git_status_init_options
          [opts git_status_opts?]
          [version integer?])
         integer?]{
 Initializes a git_status_options with default values. Equivalent to creating an instance with GIT_STATUS_OPTIONS_INIT.

}

@defproc[(git_status_list_entrycount
          [statuslist status_list?])
         integer?]{
 Gets the count of status entries in this list.

 If there are no changes in status (at least according the options given when the status list was created), this can return 0.

}

@defproc[(git_status_list_free
          [statuslist status_list?])
         void?]{
 Free an existing status list

}

@defproc[(git_status_list_new
          [repo repository?]
          [opts git_status_opts?])
         status_list?]{
 Gather file status information and populate the git_status_list.

 Note that if a pathspec is given in the git_status_options to filter the status, then the results from rename detection (if you enable it) may not be accurate. To do rename detection properly, this must be called with no pathspec so that all files can be considered.

}

@defproc[(git_status_should_ignore
          [repo repository?]
          [path string?])
         boolean?]{
 Test if the ignore rules apply to a given file.

 This function checks the ignore rules to see if they would apply to the given file. This indicates if the file would be ignored regardless of whether the file is already in the index or committed to the repository.

 One way to think of this is if you were to do "git add ." on the directory containing the file, would it be added or not?
}
