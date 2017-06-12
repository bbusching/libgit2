#lang scribble/manual

@(require (for-label racket))

@title{Tag}

@defmodule[libgit2/include/tag]


@defproc[(git_tag_annotation_create
          [oid oid?]
          [repo repository?]
          [tag_name string?]
          [target object?]
          [tagger signature?]
          [message string?])
         integer?]{
 Create a new tag in the object database pointing to a git_object

 The message will not be cleaned up. This can be achieved through git_message_prettify().

}

@defproc[(git_tag_create
          [oid oid?]
          [repo repository?]
          [tag_name string?]
          [target object?]
          [tagger signature?]
          [message string?]
          [force boolean?])
         integer?]{
 Create a new tag in the repository from an object

 A new reference will also be created pointing to this tag object. If force is true and a reference already exists with the given name, it'll be replaced.

 The message will not be cleaned up. This can be achieved through git_message_prettify().

 The tag name will be checked for validity. You must avoid the characters '~', '^', ':', '\', '?', '[', and '*', and the sequences ".." and @"@{" which have special meaning to revparse.

}

@defproc[(git_tag_create_frombuffer
          [oid oid?]
          [repo repository?]
          [buffer string?]
          [force boolean?])
         integer?]{
 Create a new tag in the repository from a buffer

}

@defproc[(git_tag_create_lightweight
          [oid oid?]
          [repo repository?]
          [tag_name string?]
          [target object?]
          [force boolean?])
         integer?]{
 Create a new lightweight tag pointing at a target object

 A new direct reference will be created pointing to this target object. If force is true and a reference already exists with the given name, it'll be replaced.

 The tag name will be checked for validity. See git_tag_create() for rules about valid names.

}

@defproc[(git_tag_delete
          [repo repository?]
          [tag_name string?])
         integer?]{
 Delete an existing tag reference.

 The tag name will be checked for validity. See git_tag_create() for rules about valid names.

}

@defproc[(git_tag_dup
          [source tag?])
         tag?]{
 Create an in-memory copy of a tag. The copy must be explicitly free'd or it will leak.

}

@defproc[(git_tag_foreach
          [repo repository?]
          [callback _git_tag_foreach_cb]
          [payload bytes?])
         integer?]{
 Call callback `cb' for each tag in the repository

}

@defproc[(git_tag_free
          [tag tag?])
         void?]{
 Close an open tag

 You can no longer use the git_tag pointer after this call.

 IMPORTANT: You MUST call this method when you are through with a tag to release memory. Failure to do so will cause a memory leak.

}

@defproc[(git_tag_id
          [tag tag?])
         oid?]{
 Get the id of a tag.

}

@defproc[(git_tag_list
          [tag_names strarray?]
          [repo repository?])
         integer?]{
 Fill a list with all the tags in the Repository

 The string array will be filled with the names of the matching tags; these values are owned by the user and should be free'd manually when no longer needed, using git_strarray_free.

}

@defproc[(git_tag_list_match
          [tag_names strarray?]
          [pattern string?]
          [repo repository?])
         integer?]{
 Fill a list with all the tags in the Repository which name match a defined pattern

 If an empty pattern is provided, all the tags will be returned.

 The string array will be filled with the names of the matching tags; these values are owned by the user and should be free'd manually when no longer needed, using git_strarray_free.

}

@defproc[(git_tag_lookup
          [repo repository?]
          [id oid?])
         tag?]{
 Lookup a tag object from the repository.

}

@defproc[(git_tag_lookup_prefix
          [repo repository?]
          [id oid?]
          [len integer?])
         tag?]{
 Lookup a tag object from the repository, given a prefix of its identifier (short id).

}

@defproc[(git_tag_message
          [tag tag?])
         string?]{
 Get the message of a tag

}

@defproc[(git_tag_name
          [tag tag?])
         string?]{
 Get the name of a tag

}

@defproc[(git_tag_owner
          [tag tag?])
         repository?]{
 Get the repository that contains the tag.

}

@defproc[(git_tag_peel
          [tag tag?])
         object?]{
 Recursively peel a tag until a non tag git_object is found

 The retrieved tag_target object is owned by the repository and should be closed with the git_object_free method.

}

@defproc[(git_tag_tagger
          [tag tag?])
         signature?]{
 Get the tagger (author) of a tag

}

@defproc[(git_tag_target
          [tag tag?])
         object?]{
 Get the tagged object of a tag

 This method performs a repository lookup for the given object and returns it

}

@defproc[(git_tag_target_id
          [tag tag?])
         oid?]{
 Get the OID of the tagged object of a tag

}

@defproc[(git_tag_target_type
          [tag tag?])
         _git_otype]{
 Get the type of a tag's tagged object
}
