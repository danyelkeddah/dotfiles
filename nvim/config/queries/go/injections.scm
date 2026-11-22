(
  (comment) @comment
  .
  (raw_string_literal) @injection.content
  (#match? @comment "^/\\* sql \\*/$")
  (#set! injection.language "sql")
)
