#lang scribble/manual

@(require (for-label racket))

@title{Submodule}

@defmodule[libgit2/include/submodule]


@defproc[(git_submodule_add_finalize
          [submodule submodule?])
         integer?]{
 Resolve the setup of a new git submodule.

 This should be called on a submodule once you have called add setup and done the clone of the submodule. This adds the .gitmodules file and the newly cloned submodule to the index to be ready to be committed (but doesn't actually do the commit).

}

@defproc[(git_submodule_add_setup
          [repo repository?]
          [url string?]
          [path string?]
          [use_gitlink boolean?])
         submodule?]{
 Set up a new git submodule for checkout.

 This does "git submodule add" up to the fetch and checkout of the submodule contents. It preps a new submodule, creates an entry in .gitmodules and creates an empty initialized repository either at the given path in the working directory or in .git/modules with a gitlink from the working directory to the new repo.

 To fully emulate "git submodule add" call this function, then open the submodule repo and perform the clone step as needed. Lastly, call git_submodule_add_finalize() to wrap up adding the new submodule and .gitmodules to the index to be ready to commit.

 You must call git_submodule_free on the submodule object when done.

}

@defproc[(git_submodule_add_to_index
          [submodule submodule?]
          [write_index boolean?])
         integer?]{
 Add current submodule HEAD commit to index of superproject.

}

@defproc[(git_submodule_branch
          [submodule submodule?])
         string?]{
 Get the branch for the submodule.

}

@defproc[(git_submodule_fetch_recurse_submodules
          [submodule submodule?])
         _git_submodule_recurse_t?]{
 Read the fetchRecurseSubmodules rule for a submodule.

 This accesses the submodule..fetchRecurseSubmodules value for the submodule that controls fetching behavior for the submodule.

 Note that at this time, libgit2 does not honor this setting and the fetch functionality current ignores submodules.

}

@defproc[(git_submodule_foreach
          [repo repository?]
          [callback git_submodule_cb]
          [payload bytes?])
         integer?]{
 Iterate over all tracked submodules of a repository.

 See the note on git_submodule above. This iterates over the tracked submodules as described therein.

 If you are concerned about items in the working directory that look like submodules but are not tracked, the diff API will generate a diff record for workdir items that look like submodules but are not tracked, showing them as added in the workdir. Also, the status API will treat the entire subdirectory of a contained git repo as a single GIT_STATUS_WT_NEW item.

}

@defproc[(git_submodule_free
          [submodule submodule?])
         void?]{
 Release a submodule

}

@defproc[(git_submodule_head_id
          [submodule submodule?])
         oid?]{
 Get the OID for the submodule in the current HEAD tree.

}

@defproc[(git_submodule_ignore
          [submodule submodule?])
         _git_submodule_ignore_t]{
 Get the ignore rule that will be used for the submodule.

 These values control the behavior of git_submodule_status() for this submodule. There are four ignore values:

 GIT_SUBMODULE_IGNORE_NONE will consider any change to the contents of the submodule from a clean checkout to be dirty, including the addition of untracked files. This is the default if unspecified. - GIT_SUBMODULE_IGNORE_UNTRACKED examines the contents of the working tree (i.e. call git_status_foreach() on the submodule) but UNTRACKED files will not count as making the submodule dirty. - GIT_SUBMODULE_IGNORE_DIRTY means to only check if the HEAD of the submodule has moved for status. This is fast since it does not need to scan the working tree of the submodule at all. - GIT_SUBMODULE_IGNORE_ALL means not to open the submodule repo. The working directory will be consider clean so long as there is a checked out version present.
}

@defproc[(git_submodule_index_id
          [submodule submodule?])
         oid?]{
 Get the OID for the submodule in the index.

}

@defproc[(git_submodule_init
          [submodule submodule?]
          [overwrite boolean?])
         integer?]{
 Copy submodule info into ".git/config" file.

 Just like "git submodule init", this copies information about the submodule into ".git/config". You can use the accessor functions above to alter the in-memory git_submodule object and control what is written to the config, overriding what is in .gitmodules.

}

@defproc[(git_submodule_location
          [submodule submodule?])
         integer?]{
 Get the locations of submodule information.

 This is a bit like a very lightweight version of git_submodule_status. It just returns a made of the first four submodule status values (i.e. the ones like GIT_SUBMODULE_STATUS_IN_HEAD, etc) that tell you where the submodule data comes from (i.e. the HEAD commit, gitmodules file, etc.). This can be useful if you want to know if the submodule is present in the working directory at this point in time, etc.

}

@defproc[(git_submodule_lookup
          [repo repository?]
          [name string?])
         submodule?]{
 Lookup submodule information by name or path.

 Given either the submodule name or path (they are usually the same), this returns a structure describing the submodule.

 There are two expected error scenarios:

 The submodule is not mentioned in the HEAD, the index, and the config, but does "exist" in the working directory (i.e. there is a subdirectory that appears to be a Git repository). In this case, this function returns GIT_EEXISTS to indicate a sub-repository exists but not in a state where a git_submodule can be instantiated. - The submodule is not mentioned in the HEAD, index, or config and the working directory doesn't contain a value git repo at that path. There may or may not be anything else at that path, but nothing that looks like a submodule. In this case, this returns GIT_ENOTFOUND.
 You must call git_submodule_free when done with the submodule.

}

@defproc[(git_submodule_name
          [submodule submodule?])
         string?]{
 Get the name of submodule.

}

@defproc[(git_submodule_open
          [submodule submodule?])
         repository?]{
 Open the repository for a submodule.

 This is a newly opened repository object. The caller is responsible for calling git_repository_free() on it when done. Multiple calls to this function will return distinct git_repository objects. This will only work if the submodule is checked out into the working directory.

}

@defproc[(git_submodule_owner
          [submodule submodule?])
         repository?]{
 Get the containing repository for a submodule.

 This returns a pointer to the repository that contains the submodule. This is a just a reference to the repository that was passed to the original git_submodule_lookup() call, so if that repository has been freed, then this may be a dangling reference.

}

@defproc[(git_submodule_path
          [submodule submodule?])
         string?]{
 Get the path to the submodule.

 The path is almost always the same as the submodule name, but the two are actually not required to match.

}

@defproc[(git_submodule_reload
          [submodule submodule?]
          [force boolean?])
         integer?]{
 Reread submodule info from config, index, and HEAD.

 Call this to reread cached submodule information for this submodule if you have reason to believe that it has changed.

}

@defproc[(git_submodule_repo_init
          [sm submodule?]
          [use_gitlink boolean?])
         repository?]{
 Set up the subrepository for a submodule in preparation for clone.

 This function can be called to init and set up a submodule repository from a submodule in preparation to clone it from its remote.

}

@defproc[(git_submodule_resolve_url
          [out buf?]
          [repo repository?]
          [url string?])
         integer?]{
 Resolve a submodule url relative to the given repository.

}

@defproc[(git_submodule_set_branch
          [repo repository?]
          [name string?]
          [branch string?])
         integer?]{
 Set the branch for the submodule in the configuration

 After calling this, you may wish to call git_submodule_sync() to write the changes to the checked out submodule repository.

}

@defproc[(git_submodule_set_fetch_recurse_submodules
          [repo repository?]
          [name string?]
          [fetch_recurse_submodules _git_submodule_recurse_t])
         integer?]{
 Set the fetchRecurseSubmodules rule for a submodule in the configuration

 This setting won't affect any existing instances.

}

@defproc[(git_submodule_set_ignore
          [repo repository?]
          [name string?]
          [ignore _git_submodule_ignore_t])
         integer?]{
 Set the ignore rule for the submodule in the configuration

 This does not affect any currently-loaded instances.

}

@defproc[(git_submodule_set_update
          [repo repository?]
          [name string?]
          [update _git_submodule_update_t])
         integer?]{
 Set the update rule for the submodule in the configuration

 This setting won't affect any existing instances.

}

@defproc[(git_submodule_set_url
          [repo repository?]
          [name string?]
          [url string?])
         integer?]{
 Set the URL for the submodule in the configuration

 After calling this, you may wish to call git_submodule_sync() to write the changes to the checked out submodule repository.

}

@defproc[(git_submodule_status
          [int unsigned]
          [repo repository?]
          [name string?]
          [ignore _git_submodule_ignore_t])
         integer?]{
 Get the status for a submodule.

 This looks at a submodule and tries to determine the status. It will return a combination of the GIT_SUBMODULE_STATUS values above. How deeply it examines the working directory to do this will depend on the git_submodule_ignore_t value for the submodule.

}

@defproc[(git_submodule_sync
          [submodule submodule?])
         integer?]{
 Copy submodule remote info into submodule repo.

 This copies the information about the submodules URL into the checked out submodule config, acting like "git submodule sync". This is useful if you have altered the URL for the submodule (or it has been altered by a fetch of upstream changes) and you need to update your local repo.

}

@defproc[(git_submodule_update
          [submodule submodule?]
          [init boolean?]
          [options git_submodule_update_opts?])
         integer?]{
 Update a submodule. This will clone a missing submodule and checkout the subrepository to the commit specified in the index of the containing repository. If the submodule repository doesn't contain the target commit (e.g. because fetchRecurseSubmodules isn't set), then the submodule is fetched using the fetch options supplied in options.

}

@defproc[(git_submodule_update_init_options
          [opts git_submodule_update_opts?]
          [version integer?])
         integer?]{
 Initializes a git_submodule_update_options with default values. Equivalent to creating an instance with GIT_SUBMODULE_UPDATE_OPTIONS_INIT.

}

@defproc[(git_submodule_update_strategy
          [submodule submodule?])
         _git_submodule_update_strategy]{
 Get the update rule that will be used for the submodule.

 This value controls the behavior of the git submodule update command. There are four useful values documented with git_submodule_update_t.

}

@defproc[(git_submodule_url
          [submodule submodule?])
         string?]{
 Get the URL for the submodule.

}

@defproc[(git_submodule_wd_id
          [submodule submodule?])
         oid?]{
 Get the OID for the submodule in the current working directory.

 This returns the OID that corresponds to looking up 'HEAD' in the checked out submodule. If there are pending changes in the index or anything else, this won't notice that. You should call git_submodule_status() for a more complete picture about the state of the working directory.
}
