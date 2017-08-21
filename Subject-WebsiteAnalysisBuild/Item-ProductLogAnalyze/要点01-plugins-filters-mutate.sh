# You can rename, remove, replace, and modify fields in your events.
# plugins-filters-mutate-options

# plugins-filters-mutate-convert
# Convert a field’s value to a different type, like turning a string to an integer. If the field value is an array, all members will be converted.
# 例子
filter {
  mutate {
    convert => { "fieldname" => "integer" }
  }
}

# plugins-filters-mutate-copy
# Copy an existing field to another field. Existing target field will be overriden.
filter {
  mutate {
     copy => { "source_field" => "dest_field" }
  }
}

# plugins-filters-mutate-gsub
# Convert a string field by applying a regular expression and a replacement. If the field is not a string, no action will be taken.
filter {
  mutate {
    gsub => [
      # replace all forward slashes with underscore
      "fieldname", "/", "_",
      # replace backslashes, question marks, hashes, and minuses
      # with a dot "."
      "fieldname2", "[\\?#-]", "."
    ]
  }
}

# plugins-filters-mutate-join
# Join an array with a separator character. Does nothing on non-array fields.
filter {
  mutate {
    join => { "fieldname" => "," }
  }
}
# plugins-filters-mutate-lowercase
# plugins-filters-mutate-replace
filter {
  mutate {
    replace => { "message" => "%{source_host}: My new message" }
  }
}

# plugins-filters-mutate-split
# Split a field to an array using a separator character. Only works on string fields.
filter {
  mutate {
     split => { "fieldname" => "," }
  }
}
# Strip whitespace from field. NOTE: this only works on leading and trailing whitespace.
filter {
  mutate {
     strip => ["field1", "field2"]
  }
}
# Update an existing field with a new value. If the field does not exist, then no action will be taken.
filter {
  mutate {
    update => { "sample" => "My new message" }
  }
}
# You can also add multiple tags at once:
filter {
  PLUGIN_NAME {
    add_tag => [ "foo_%{somefield}", "taggedy_tag"]
  }
}
# If the event has field "somefield" == "hello" this filter, on success, would add a tag foo_hello (and the second example would of course add a taggedy_tag tag).

# Add a unique ID to the plugin instance, this ID is used for tracking information for a specific configuration of the plugin.
output { stdout { id ⇒ "ABC" } }
# If you don’t explicitely set this variable Logstash will generate a unique name.

# If this filter is successful, remove arbitrary tags from the event. Tags can be dynamic and include parts of the event using the %{field} syntax.
# You can also remove multiple tags at once:
filter {
  PLUGIN_NAME {
    remove_tag => [ "foo_%{somefield}", "sad_unwanted_tag"]
  }
}