#lang scribble/manual

@(require (for-label racket))

@title{Remote}

@defmodule[libgit2/include/remote]


@defproc[(git_remote_add_fetch
          [repo repository?]
          [remote string?]
          [refspec string?])
         integer?]{
 Add a fetch refspec to the remote's configuration

 Add the given refspec to the fetch list in the configuration. No loaded remote instances will be affected.

}

@defproc[(git_remote_add_push
          [repo repository?]
          [remote string?]
          [refspec string?])
         integer?]{
 Add a push refspec to the remote's configuration

 Add the given refspec to the push list in the configuration. No loaded remote instances will be affected.

}

@defproc[(git_remote_autotag
          [remote remote?])
         _git_remote_autotag_opt_t]{
 Retrieve the tag auto-follow setting

}

@defproc[(git_remote_connect
          [remote remote?]
          [direction _git_direction]
          [callbacks remote_callbacks?]
          [proxy_opts git_proxy_opts?]
          [custom_headers strarray?])
         integer?]{
 Open a connection to a remote

 The transport is selected based on the URL. The direction argument is due to a limitation of the git protocol (over TCP or SSH) which starts up a specific binary which can only do the one or the other.

}

@defproc[(git_remote_connected
          [remote remote?])
         boolean?]{
 Check whether the remote is connected

 Check whether the remote's underlying transport is connected to the remote host.

}

@defproc[(git_remote_create
          [repo repository?]
          [name string?]
          [url string?])
         remote?]{
 Add a remote with the default fetch refspec to the repository's configuration.

}

@defproc[(git_remote_create_anonymous
          [repo repository?]
          [url string?])
         remote?]{
 Create an anonymous remote

 Create a remote with the given url in-memory. You can use this when you have a URL instead of a remote's name.

}

@defproc[(git_remote_create_with_fetchspec
          [repo repository?]
          [name string?]
          [url string?]
          [fetch string?])
         remote?]{
 Add a remote with the provided fetch refspec (or default if NULL) to the repository's configuration.

}

@defproc[(git_remote_default_branch
          [out buf?]
          [remote remote?])
         integer?]{
 Retrieve the name of the remote's default branch

 The default branch of a repository is the branch which HEAD points to. If the remote does not support reporting this information directly, it performs the guess as git does; that is, if there are multiple branches which point to the same commit, the first one is chosen. If the master branch is a candidate, it wins.

 This function must only be called after connecting.

}

@defproc[(git_remote_delete
          [repo repository?]
          [name string?])
         integer?]{
 Delete an existing persisted remote.

 All remote-tracking branches and configuration settings for the remote will be removed.

}

@defproc[(git_remote_disconnect
          [remote remote?])
         void?]{
 Disconnect from the remote

 Close the connection to the remote.

}

@defproc[(git_remote_download
          [remote remote?]
          [refspecs strarray?]
          [opts (or/c git_fetch_opts? #f)])
         integer?]{
 Download and index the packfile

 Connect to the remote if it hasn't been done yet, negotiate with the remote git which objects are missing, download and index the packfile.

 The .idx file will be created and both it and the packfile with be renamed to their final name.

}

@defproc[(git_remote_dup
          [source remote?])
         remote?]{
 Create a copy of an existing remote. All internal strings are also duplicated. Callbacks are not duplicated.

 Call git_remote_free to free the data.

}

@defproc[(git_remote_fetch
          [remote remote?]
          [refspecs (or/c strarray? #f)]
          [opts (or/c git_fetch_options? #f)]
          [reflog_message (or/c string? #f)])
         integer?]{
 Download new data and update tips

 Convenience function to connect to a remote, download the data, disconnect and update the remote-tracking branches.

}

@defproc[(git_remote_free
          [remote remote?])
         void?]{
 Free the memory associated with a remote

 This also disconnects from the remote, if the connection has not been closed yet (using git_remote_disconnect).

}

@defproc[(git_remote_get_fetch_refspecs
          [array strarray?]
          [remote remote?])
         integer?]{
 Get the remote's list of fetch refspecs

 The memory is owned by the user and should be freed with git_strarray_free.

}

@defproc[(git_remote_get_push_refspecs
          [array strarray?]
          [remote remote?])
         integer?]{
 Get the remote's list of push refspecs

 The memory is owned by the user and should be freed with git_strarray_free.

}

@defproc[(git_remote_get_refspec
          [remote remote?]
          [n integer?])
         integer?]{
 Get a refspec from the remote

}

@defproc[(git_remote_init_callbacks
          [opts git_remote_callbacks?]
          [version integer?])
         integer?]{
 Initializes a git_remote_callbacks with default values. Equivalent to creating an instance with GIT_REMOTE_CALLBACKS_INIT.

}

@defproc[(git_remote_is_valid_name
          [remote_name string?])
         boolean?]{
 Ensure the remote name is well-formed.

}

@defproc[(git_remote_list
          [out strarray?]
          [repo repository?])
         integer?]{
 Get a list of the configured remotes for a repo

 The string array must be freed by the user.

}

@defproc[(git_remote_lookup
          [repo repository?]
          [name string?])
         remote?]{
 Get the information for a particular remote

 The name will be checked for validity. See git_tag_create() for rules about valid names.

}

@defproc[(git_remote_ls
          [remote remote?])
         any]{
 Get the remote repository's reference advertisement list

 Get the list of references with which the server responds to a new connection.

 The remote (or more exactly its transport) must have connected to the remote repository. This list is available as soon as the connection to the remote is initiated and it remains available after disconnecting.

 The memory belongs to the remote. The pointer will be valid as long as a new connection is not initiated, but it is recommended that you make a copy in order to make use of the data.

 Returns @racket[(values (out : (_cpointer remote_head?))
                         (size : integer?))]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}

@defproc[(git_remote_name
          [remote remote?])
         string?]{
 Get the remote's name

}

@defproc[(git_remote_owner
          [remote remote?])
         repository?]{
 Get the remote's repository

}

@defproc[(git_remote_prune
          [remote remote?]
          [callbacks (or/c git_remote_callbacks? #f)])
         integer?]{
 Prune tracking refs that are no longer present on remote

}

@defproc[(git_remote_prune_refs
          [remote remote?])
         integer?]{
 Retrieve the ref-prune setting

}

@defproc[(git_remote_push
          [remote remote?]
          [refspecs strarray?]
          [opts (or/c git_push_opns? #f)])
         integer?]{
 Perform a push

 Peform all the steps from a push.

}

@defproc[(git_remote_pushurl
          [remote remote?])
         string?]{
 Get the remote's url for pushing

 If url.*.pushInsteadOf has been configured for this URL, it will return the modified URL.

}

@defproc[(git_remote_refspec_count
          [remote remote?])
         integer?]{
 Get the number of refspecs for a remote

}

@defproc[(git_remote_rename
          [problems strarray?]
          [repo repository?]
          [name string?]
          [new_name string?])
         integer?]{
 Give the remote a new name

 All remote-tracking branches and configuration settings for the remote are updated.

 The new name will be checked for validity. See git_tag_create() for rules about valid names.

 No loaded instances of a the remote with the old name will change their name or their list of refspecs.

}

@defproc[(git_remote_set_autotag
          [repo repository?]
          [remote string?]
          [value git_remote_autotag_option_t])
         integer?]{
 Set the remote's tag following setting.

 The change will be made in the configuration. No loaded remotes will be affected.

}

@defproc[(git_remote_set_pushurl
          [repo repository?]
          [remote string?]
          [url string?])
         integer?]{
 Set the remote's url for pushing in the configuration.

 Remote objects already in memory will not be affected. This assumes the common case of a single-url remote and will otherwise return an error.

}

@defproc[(git_remote_set_url
          [repo repository?]
          [remote string?]
          [url string?])
         integer?]{
 Set the remote's url in the configuration

 Remote objects already in memory will not be affected. This assumes the common case of a single-url remote and will otherwise return an error.

}

@defproc[(git_remote_stats
          [remote remote?])
         git_transfer_progress?]{
 Get the statistics structure that is filled in by the fetch operation.

}

@defproc[(git_remote_stop
          [remote remote?])
         void?]{
 Cancel the operation

 At certain points in its operation, the network code checks whether the operation has been cancelled and if so stops the operation.

}

@defproc[(git_remote_update_tips
          [remote remote?]
          [callbacks git_remote_callbacks?]
          [update_fetchhead boolean?]
          [download_tags git_remote_autotag_option_t]
          [reflog_message string?])
         integer?]{
 Update the tips to the new state

}

@defproc[(git_remote_upload
          [remote remote?]
          [refspecs strarray?]
          [opts git_push_options?])
         integer?]{
 Create a packfile and send it to the server

 Connect to the remote if it hasn't been done yet, negotiate with the remote git which objects are missing, create a packfile with the missing objects and send it.

}

@defproc[(git_remote_url
          [remote remote?])
         string?]{
 Get the remote's url

 If url.*.insteadOf has been configured for this URL, it will return the modified URL.
}

@defproc[(git_fetch_init_options
          [opts git_fetch_opts?]
          [version integer?])
         integer?]{
 Initializes a git_fetch_options struct.
 
}

@defproc[(git_push_init_options
          [opts git_push_opts?]
          [version integer?])
         integer?]{
 Initializes a git_fetch_options struct.
 
}
