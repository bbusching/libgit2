#lang scribble/manual

@(require (for-label racket))

@title{Repository}

@defmodule[libgit2/include/repository]


@defproc[(git_repository_config
          [repo repository?])
         config?]{
 Get the configuration file for this repository.

 If a configuration file has not been set, the default config set for the repository will be returned, including global and system configurations (if they are available).

 The configuration file must be freed once it's no longer being used by the user.

}

@defproc[(git_repository_config_snapshot
          [repo repository?])
         config?]{
 Get a snapshot of the repository's configuration

 Convenience function to take a snapshot from the repository's configuration. The contents of this snapshot will not change, even if the underlying config files are modified.

 The configuration file must be freed once it's no longer being used by the user.

}

@defproc[(git_repository_detach_head
          [repo repository?])
         integer?]{
 Detach the HEAD.

 If the HEAD is already detached and points to a Commit, 0 is returned.

 If the HEAD is already detached and points to a Tag, the HEAD is updated into making it point to the peeled Commit, and 0 is returned.

 If the HEAD is already detached and points to a non commitish, the HEAD is unaltered, and -1 is returned.

 Otherwise, the HEAD will be detached and point to the peeled Commit.

}

@defproc[(git_repository_discover
          [out buf?]
          [start_path string?]
          [across_fs boolean?]
          [ceiling_dirs string?])
         integer?]{
 Look for a git repository and copy its path in the given buffer. The lookup start from base_path and walk across parent directories if nothing has been found. The lookup ends when the first repository is found, or when reaching a directory referenced in ceiling_dirs or when the filesystem changes (in case across_fs is true).

 The method will automatically detect if the repository is bare (if there is a repository).

}

@defproc[(git_repository_fetchhead_foreach
          [repo repository?]
          [callback git_repository_fetchhead_foreach_cb]
          [payload bytes?])
         integer?]{
 Invoke 'callback' for each entry in the given FETCH_HEAD file.

 Return a non-zero value from the callback to stop the loop.

}

@defproc[(git_repository_free
          [repo repository?])
         void?]{
 Free a previously allocated repository

 Note that after a repository is free'd, all the objects it has spawned will still exist until they are manually closed by the user with git_object_free, but accessing any of the attributes of an object without a backing repository will result in undefined behavior

}

@defproc[(git_repository_get_namespace
          [repo repository?])
         string?]{
 Get the currently active namespace for this repository

}

@defproc[(git_repository_hashfile
          [out oid?]
          [repo repository?]
          [path string?]
          [type _git_otype]
          [as_path string?])
         integer?]{
 Calculate hash of file using repository filtering rules.

 If you simply want to calculate the hash of a file on disk with no filters, you can just use the git_odb_hashfile() API. However, if you want to hash a file in the repository and you want to apply filtering rules (e.g. crlf filters) before generating the SHA, then use this function.

 Note: if the repository has core.safecrlf set to fail and the filtering triggers that failure, then this function will return an error and not calculate the hash of the file.

}

@defproc[(git_repository_head
          [repo repository?])
         reference?]{
 Retrieve and resolve the reference pointed at by HEAD.

 The returned git_reference will be owned by caller and git_reference_free() must be called when done with it to release the allocated memory and prevent a leak.

}

@defproc[(git_repository_head_detached
          [repo repository?])
         boolean?]{
 Check if a repository's HEAD is detached

 A repository's HEAD is detached when it points directly to a commit instead of a branch.

}

@defproc[(git_repository_head_unborn
          [repo repository?])
         boolean?]{
 Check if the current branch is unborn

 An unborn branch is one named from HEAD but which doesn't exist in the refs namespace, because it doesn't have any commit to point to.

}

@defproc[(git_repository_ident
          [repo repository?])
         integer?]{
 Retrieve the configured identity to use for reflogs

 The memory is owned by the repository and must not be freed by the user.

 Returns @racket[(values (name : string?)
                         (email : string?))]. See @secref["values" #:doc '(lib "scribblings/reference/reference.scrbl")]
}

@defproc[(git_repository_index
          [repo repository?])
         index?]{
 Get the Index file for this repository.

 If a custom index has not been set, the default index for the repository will be returned (the one located in .git/index).

 The index must be freed once it's no longer being used by the user.

}

@defproc[(git_repository_init
          [path string?]
          [is_bare #f])
         repository?]{
 Creates a new Git repository in the given folder.

 TODO: - Reinit the repository

}

@defproc[(git_repository_init_ext
          [repo_path string?]
          [opts git_repository_init_opts?])
         repository?]{
 Create a new Git repository in the given folder with extended controls.

 This will initialize a new git repository (creating the repo_path if requested by flags) and working directory as needed. It will auto-detect the case sensitivity of the file system and if the file system supports file mode bits correctly.

}

@defproc[(git_repository_init_init_options
          [opts git_repository_init_options?]
          [version integer?])
         integer?]{
 Initializes a git_repository_init_options with default values. Equivalent to creating an instance with GIT_REPOSITORY_INIT_OPTIONS_INIT.

}

@defproc[(git_repository_is_bare
          [repo repository?])
         boolean?]{
 Check if a repository is bare

}

@defproc[(git_repository_is_empty
          [repo repository?])
         boolean?]{
 Check if a repository is empty

 An empty repository has just been initialized and contains no references apart from HEAD, which must be pointing to the unborn master branch.

}

@defproc[(git_repository_is_shallow
          [repo repository?])
         boolean?]{
 Determine if the repository was a shallow clone

}

@defproc[(git_repository_mergehead_foreach
          [repo repository?]
          [callback git_repository_mergehead_foreach_cb]
          [payload bytes?])
         integer?]{
 If a merge is in progress, invoke 'callback' for each commit ID in the MERGE_HEAD file.

 Return a non-zero value from the callback to stop the loop.

}

@defproc[(git_repository_message
          [out buf?]
          [repo repository?])
         integer?]{
 Retrieve git's prepared message

 Operations such as git revert/cherry-pick/merge with the -n option stop just short of creating a commit with the changes and save their prepared message in .git/MERGE_MSG so the next git-commit execution can present it to the user for them to amend if they wish.

 Use this function to get the contents of this file. Don't forget to remove the file after you create the commit.

}

@defproc[(git_repository_message_remove
          [repo repository?])
         integer?]{
 Remove git's prepared message.

 Remove the message that git_repository_message retrieves.

}

@defproc[(git_repository_new)
         repository?]{
 Create a new repository with neither backends nor config object

 Note that this is only useful if you wish to associate the repository with a non-filesystem-backed object database and config store.

}

@defproc[(git_repository_odb
          [repo repository?])
         odb?]{
 Get the Object Database for this repository.

 If a custom ODB has not been set, the default database for the repository will be returned (the one located in .git/objects).

 The ODB must be freed once it's no longer being used by the user.

}

@defproc[(git_repository_open
          [path string?])
         repository?]{
 Open a git repository.

 The 'path' argument must point to either a git repository folder, or an existing work dir.

 The method will automatically detect if 'path' is a normal or bare repository or fail is 'path' is neither.

}

@defproc[(git_repository_open_bare
          [bare_path string?])
         repository?]{
 Open a bare repository on the serverside.

 This is a fast open for bare repositories that will come in handy if you're e.g. hosting git repositories and need to access them efficiently

}

@defproc[(git_repository_open_ext
          [path string?]
          [flags integer?]
          [ceiling_dirs string?])
         repository?]{
 Find and open a repository with extended controls.

}

@defproc[(git_repository_path
          [repo repository?])
         string?]{
 Get the path of this repository

 This is the path of the .git folder for normal repositories, or of the repository itself for bare repositories.

}

@defproc[(git_repository_refdb
          [repo repository?])
         refdb?]{
 Get the Reference Database Backend for this repository.

 If a custom refsdb has not been set, the default database for the repository will be returned (the one that manipulates loose and packed references in the .git directory).

 The refdb must be freed once it's no longer being used by the user.

}

@defproc[(git_repository_reinit_filesystem
          [repo repository?]
          [recurse_submodules boolean?])
         integer?]{
 Update the filesystem config settings for an open repository

 When a repository is initialized, config values are set based on the properties of the filesystem that the repository is on, such as "core.ignorecase", "core.filemode", "core.symlinks", etc. If the repository is moved to a new filesystem, these properties may no longer be correct and API calls may not behave as expected. This call reruns the phase of repository initialization that sets those properties to compensate for the current filesystem of the repo.

}

@defproc[(git_repository_set_bare
          [repo repository?])
         integer?]{
 Set a repository to be bare.

 Clear the working directory and set core.bare to true. You may also want to call git_repository_set_index(repo, NULL) since a bare repo typically does not have an index, but this function will not do that for you.

}

@defproc[(git_repository_set_config
          [repo repository?]
          [config config?])
         void?]{
 Set the configuration file for this repository

 This configuration file will be used for all configuration queries involving this repository.

 The repository will keep a reference to the config file; the user must still free the config after setting it to the repository, or it will leak.

}

@defproc[(git_repository_set_head
          [repo repository?]
          [refname string?])
         integer?]{
 Make the repository HEAD point to the specified reference.

 If the provided reference points to a Tree or a Blob, the HEAD is unaltered and -1 is returned.

 If the provided reference points to a branch, the HEAD will point to that branch, staying attached, or become attached if it isn't yet. If the branch doesn't exist yet, no error will be return. The HEAD will then be attached to an unborn branch.

 Otherwise, the HEAD will be detached and will directly point to the Commit.

}

@defproc[(git_repository_set_head_detached
          [repo repository?]
          [commitish oid?])
         integer?]{
 Make the repository HEAD directly point to the Commit.

 If the provided committish cannot be found in the repository, the HEAD is unaltered and GIT_ENOTFOUND is returned.

 If the provided commitish cannot be peeled into a commit, the HEAD is unaltered and -1 is returned.

 Otherwise, the HEAD will eventually be detached and will directly point to the peeled Commit.

}

@defproc[(git_repository_set_head_detached_from_annotated
          [repo repository?]
          [commitish annotated_commit?])
         integer?]{
 Make the repository HEAD directly point to the Commit.

 This behaves like git_repository_set_head_detached() but takes an annotated commit, which lets you specify which extended sha syntax string was specified by a user, allowing for more exact reflog messages.

 See the documentation for git_repository_set_head_detached().

}

@defproc[(git_repository_set_ident
          [repo repository?]
          [name string?]
          [email string?])
         integer?]{
 Set the identity to be used for writing reflogs

 If both are set, this name and email will be used to write to the reflog. Pass NULL to unset. When unset, the identity will be taken from the repository's configuration.

}

@defproc[(git_repository_set_index
          [repo repository?]
          [index index?])
         void?]{
 Set the index file for this repository

 This index will be used for all index-related operations involving this repository.

 The repository will keep a reference to the index file; the user must still free the index after setting it to the repository, or it will leak.

}

@defproc[(git_repository_set_namespace
          [repo repository?]
          [nmspace string?])
         integer?]{
 Sets the active namespace for this Git Repository

 This namespace affects all reference operations for the repo. See man gitnamespaces

}

@defproc[(git_repository_set_odb
          [repo repository?]
          [odb odb?])
         void?]{
 Set the Object Database for this repository

 The ODB will be used for all object-related operations involving this repository.

 The repository will keep a reference to the ODB; the user must still free the ODB object after setting it to the repository, or it will leak.

}

@defproc[(git_repository_set_refdb
          [repo repository?]
          [refdb refdb?])
         void?]{
 Set the Reference Database Backend for this repository

 The refdb will be used for all reference related operations involving this repository.

 The repository will keep a reference to the refdb; the user must still free the refdb object after setting it to the repository, or it will leak.

}

@defproc[(git_repository_set_workdir
          [repo repository?]
          [workdir string?]
          [update_gitlink boolean?])
         integer?]{
 Set the path to the working directory for this repository

 The working directory doesn't need to be the same one that contains the .git folder for this repository.

 If this repository is bare, setting its working directory will turn it into a normal repository, capable of performing all the common workdir operations (checkout, status, index manipulation, etc).

}

@defproc[(git_repository_state
          [repo repository?])
         integer?]{
 Determines the status of a git repository - ie, whether an operation (merge, cherry-pick, etc) is in progress.

}

@defproc[(git_repository_state_cleanup
          [repo repository?])
         integer?]{
 Remove all the metadata associated with an ongoing command like merge, revert, cherry-pick, etc. For example: MERGE_HEAD, MERGE_MSG, etc.

}

@defproc[(git_repository_workdir
          [repo repository?])
         string?]{
 Get the path of the working directory for this repository

 If the repository is bare, this function will always return NULL.

}

@defproc[(git_repository_wrap_odb
          [odb odb?])
         repository?]{
 Create a "fake" repository to wrap an object database

 Create a repository object to wrap an object database to be used with the API when all you have is an object database. This doesn't have any paths associated with it, so use with care.
}
