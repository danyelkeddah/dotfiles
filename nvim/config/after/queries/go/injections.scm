; extends

(
  (const_spec
    (comment) @sql_comment
    value: (expression_list
      (raw_string_literal
        (raw_string_literal_content) @injection.content)))
  (#eq? @sql_comment "/* sql */")
  (#set! injection.language "sql")
)
