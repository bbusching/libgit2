#lang scribble/manual

@(require (for-label racket))

@title{Config}

@defmodule[libgit2/include/config]


@defproc[(git_config_add_backend
          [cfg config?]
          [file config_backend?]
          [level _git_config_level_t]
          [force boolean?])
         integer?]{
 Add a generic config file instance to an existing config

 Note that the configuration object will free the file automatically.

 Further queries on this config object will access each of the config file instances in order (instances with a higher priority level will be accessed first).

}

@defproc[(git_config_add_file_ondisk
          [cfg config?]
          [path string?]
          [level git_config_level_t]
          [force boolean?])
         integer?]{
 Add an on-disk config file instance to an existing config

 The on-disk file pointed at by path will be opened and parsed; it's expected to be a native Git config file following the default Git config syntax (see man git-config).

 If the file does not exist, the file will still be added and it will be created the first time we write to it.

 Note that the configuration object will free the file automatically.

 Further queries on this config object will access each of the config file instances in order (instances with a higher priority level will be accessed first).

}

@defproc[(git_config_backend_foreach_match
          [backend config_backend?]
          [regexp string?]
          [callback git_config_foreach_cb]
          [payload bytes?])
         integer?]{
 Perform an operation on each config variable in given config backend matching a regular expression.

 This behaviors like git_config_foreach_match except instead of all config entries it just enumerates through the given backend entry.

}

@defproc[(git_config_delete_entry
          [cfg config?]
          [name string?])
         integer?]{
 Delete a config variable from the config file with the highest level (usually the local one).

}

@defproc[(git_config_delete_multivar
          [cfg config?]
          [name string?]
          [regexp string?])
         integer?]{
 Deletes one or several entries from a multivar in the local config file.

}

@defproc[(git_config_entry_free
          [entry config_entry?])
         void?]{
 Free a config entry

}

@defproc[(git_config_find_global
          [out buf?])
         integer?]{
 Locate the path to the global configuration file

 The user or global configuration file is usually located in $HOME/.gitconfig.

 This method will try to guess the full path to that file, if the file exists. The returned path may be used on any git_config call to load the global configuration file.

 This method will not guess the path to the xdg compatible config file (.config/git/config).

}

@defproc[(git_config_find_programdata
          [out buf?])
         integer?]{
 Locate the path to the configuration file in ProgramData

 Look for the file in %PROGRAMDATA% used by portable git.

}

@defproc[(git_config_find_system
          [out buf?])
         integer?]{
 Locate the path to the system configuration file

 If /etc/gitconfig doesn't exist, it will look for %PROGRAMFILES%.

}

@defproc[(git_config_find_xdg
          [out buf?])
         integer?]{
 Locate the path to the global xdg compatible configuration file

 The xdg compatible configuration file is usually located in $HOME/.config/git/config.

 This method will try to guess the full path to that file, if the file exists. The returned path may be used on any git_config call to load the xdg compatible configuration file.

}

@defproc[(git_config_foreach
          [cfg config?]
          [callback git_config_foreach_cb]
          [payload bytes?])
         integer?]{
 Perform an operation on each config variable.

 The callback receives the normalized name and value of each variable in the config backend, and the data pointer passed to this function. If the callback returns a non-zero value, the function stops iterating and returns that value to the caller.

 The pointers passed to the callback are only valid as long as the iteration is ongoing.

}

@defproc[(git_config_foreach_match
          [cfg config?]
          [regexp string?]
          [callback git_config_foreach_cb]
          [payload bytes?])
         integer?]{
 Perform an operation on each config variable matching a regular expression.

 This behaviors like git_config_foreach with an additional filter of a regular expression that filters which config keys are passed to the callback.

 The pointers passed to the callback are only valid as long as the iteration is ongoing.

}

@defproc[(git_config_free
          [cfg config?])
         void?]{
 Free the configuration and its associated memory and files

}

@defproc[(git_config_get_bool
          [out boolean?]
          [cfg config?]
          [name string?])
         integer?]{
 Get the value of a boolean config variable.

 This function uses the usual C convention of 0 being false and anything else true.

 All config files will be looked into, in the order of their defined level. A higher level means a higher priority. The first occurrence of the variable will be returned here.

}

@defproc[(git_config_get_entry
          [cfg config?]
          [name string?])
         config_entry?]{
 Get the git_config_entry of a config variable.

 Free the git_config_entry after use with git_config_entry_free().

 git_config_get_int32(int32_t *out, const git_config *cfg, const char *name)

 Get the value of an integer config variable.

 All config files will be looked into, in the order of their defined level. A higher level means a higher priority. The first occurrence of the variable will be returned here.

 git_config_get_int64(int64_t *out, const git_config *cfg, const char *name)

 Get the value of a long integer config variable.

 All config files will be looked into, in the order of their defined level. A higher level means a higher priority. The first occurrence of the variable will be returned here.

}

@defproc[(git_config_get_mapped
          [out boolean?]
          [cfg config?]
          [name string?]
          [maps git_cvar_map?]
          [map_n integer?])
         integer?]{
 Query the value of a config variable and return it mapped to an integer constant.

 This is a helper method to easily map different possible values to a variable to integer constants that easily identify them.

 A mapping array looks as follows:

 git_cvar_map autocrlf_mapping[] = {     {GIT_CVAR_FALSE, NULL, GIT_AUTO_CRLF_FALSE},        {GIT_CVAR_TRUE, NULL, GIT_AUTO_CRLF_TRUE},      {GIT_CVAR_STRING, "input", GIT_AUTO_CRLF_INPUT},        {GIT_CVAR_STRING, "default", GIT_AUTO_CRLF_DEFAULT}};
 On any "false" value for the variable (e.g. "false", "FALSE", "no"), the mapping will store GIT_AUTO_CRLF_FALSE in the out parameter.

 The same thing applies for any "true" value such as "true", "yes" or "1", storing the GIT_AUTO_CRLF_TRUE variable.

 Otherwise, if the value matches the string "input" (with case insensitive comparison), the given constant will be stored in out, and likewise for "default".

 If not a single match can be made to store in out, an error code will be returned.

}

@defproc[(git_config_get_multivar_foreach
          [cfg config?]
          [name string?]
          [regexp string?]
          [callback git_config_foreach_cb]
          [payload ?])
         integer?]{
 Get each value of a multivar in a foreach callback

 The callback will be called on each variable found

}

@defproc[(git_config_get_path
          [out buf?]
          [cfg config?]
          [name string?])
         integer?]{
 Get the value of a path config variable.

 A leading '~' will be expanded to the global search path (which defaults to the user's home directory but can be overridden via git_libgit2_opts().

 All config files will be looked into, in the order of their defined level. A higher level means a higher priority. The first occurrence of the variable will be returned here.

}

@defproc[(git_config_get_string
          [out string?]
          [cfg config?]
          [name string?])
         integer?]{
 Get the value of a string config variable.

 This function can only be used on snapshot config objects. The string is owned by the config and should not be freed by the user. The pointer will be valid until the config is freed.

 All config files will be looked into, in the order of their defined level. A higher level means a higher priority. The first occurrence of the variable will be returned here.

}

@defproc[(git_config_get_string_buf
          [out buf?]
          [cfg config?]
          [name string?])
         integer?]{
 Get the value of a string config variable.

 The value of the config will be copied into the buffer.

 All config files will be looked into, in the order of their defined level. A higher level means a higher priority. The first occurrence of the variable will be returned here.

}

@defproc[(git_config_init_backend
          [backend config_backend?]
          [int integer?])
         integer?]{
 Initializes a git_config_backend with default values. Equivalent to creating an instance with GIT_CONFIG_BACKEND_INIT.

}

@defproc[(git_config_iterator_free
          [iter config_iterator?])
         void?]{
 Free a config iterator

}

@defproc[(git_config_iterator_glob_new
          [cfg config?]
          [regexp string?])
         config_iterator?]{
 Iterate over all the config variables whose name matches a pattern

 Use git_config_next to advance the iteration and git_config_iterator_free when done.

}

@defproc[(git_config_iterator_new
          [cfg config?])
         config_iterator?]{
 Iterate over all the config variables

 Use git_config_next to advance the iteration and git_config_iterator_free when done.

}

@defproc[(git_config_lock
          [cfg config?])
         transaction?]{
 Lock the backend with the highest priority

 Locking disallows anybody else from writing to that backend. Any updates made after locking will not be visible to a reader until the file is unlocked.

 You can apply the changes by calling git_transaction_commit() before freeing the transaction. Either of these actions will unlock the config.

}

@defproc[(git_config_lookup_map_value
          [out boolean?]
          [maps git_cvar_map?]
          [map_n size_t]
          [value string?])
         integer?]{
 Maps a string value to an integer constant

}

@defproc[(git_config_multivar_iterator_new
          [cfg config?]
          [name string?]
          [regexp string?])
         config_iterator?]{
 Get each value of a multivar

}

@defproc[(git_config_new
          )
         config?]{
 Allocate a new configuration object

 This object is empty, so you have to add a file to it before you can do anything with it.

}

@defproc[(git_config_next
          [iter config_iterator?])
         config_entry?]{
 Return the current entry and advance the iterator

 The pointers returned by this function are valid until the iterator is freed.

}

@defproc[(git_config_open_default)
         config?]{
 Open the global, XDG and system configuration files

 Utility wrapper that finds the global, XDG and system configuration files and opens them into a single prioritized config object that can be used when accessing default config data outside a repository.

}

@defproc[(git_config_open_global
          [config config?])
         config?]{
 Open the global/XDG configuration file according to git's rules

 Git allows you to store your global configuration at $HOME/.config or $XDG_CONFIG_HOME/git/config. For backwards compatability, the XDG file shouldn't be used unless the use has created it explicitly. With this function you'll open the correct one to write to.

}

@defproc[(git_config_open_level
          [parent config?]
          [level git_config_level_t])
         config?]{
 Build a single-level focused config object from a multi-level one.

 The returned config object can be used to perform get/set/delete operations on a single specific level.

 Getting several times the same level from the same parent multi-level config will return different config instances, but containing the same config_file instance.

}

@defproc[(git_config_open_ondisk
          [path string?])
         config?]{
 Create a new config instance containing a single on-disk file

 This method is a simple utility wrapper for the following sequence of calls: - git_config_new - git_config_add_file_ondisk

}

@defproc[(git_config_parse_bool
          [out boolean?]
          [value string?])
         integer?]{
 Parse a string value as a bool.

 Valid values for true are: 'true', 'yes', 'on', 1 or any number different from 0 Valid values for false are: 'false', 'no', 'off', 0

 git_config_parse_int32(int32_t *out, const char *value)

 Parse a string value as an int32.

 An optional value suffix of 'k', 'm', or 'g' will cause the value to be multiplied by 1024, 1048576, or 1073741824 prior to output.

 git_config_parse_int64(int64_t *out, const char *value)

 Parse a string value as an int64.

 An optional value suffix of 'k', 'm', or 'g' will cause the value to be multiplied by 1024, 1048576, or 1073741824 prior to output.

}

@defproc[(git_config_parse_path
          [out buf?]
          [value string?])
         integer?]{
 Parse a string value as a path.

 A leading '~' will be expanded to the global search path (which defaults to the user's home directory but can be overridden via git_libgit2_opts().

 If the value does not begin with a tilde, the input will be returned.

}

@defproc[(git_config_set_bool
          [cfg config?]
          [name string?]
          [value boolean?])
         integer?]{
 Set the value of a boolean config variable in the config file with the highest level (usually the local one).

 git_config_set_int32(git_config *cfg, const char *name, int32_t value)

 Set the value of an integer config variable in the config file with the highest level (usually the local one).

 git_config_set_int64(git_config *cfg, const char *name, int64_t value)

 Set the value of a long integer config variable in the config file with the highest level (usually the local one).

}

@defproc[(git_config_set_multivar
          [cfg config?]
          [name string?]
          [regexp string?]
          [value string?])
         integer?]{
 Set a multivar in the local config file.

}

@defproc[(git_config_set_string
          [cfg config?]
          [name string?]
          [value string?])
         integer?]{
 Set the value of a string config variable in the config file with the highest level (usually the local one).

 A copy of the string is made and the user is free to use it afterwards.

}

@defproc[(git_config_snapshot
          [config config?])
         config?]{
 Create a snapshot of the configuration

 Create a snapshot of the current state of a configuration, which allows you to look into a consistent view of the configuration for looking up complex values (e.g. a remote, submodule).

 The string returned when querying such a config object is valid until it is freed.
}
