##
## to compile use
##    $ racc -o parser.rb parser.y


class MarkdownParser
  rule
    # Start rule
    document        : element_list

    # Document can contain multiple elements
    element_list    : element
                   | element_list element

    # An element can be a header, a paragraph, or a list item
    element         : header             { puts "REDUCE header" }
                   | paragraph           { puts "REDUCE paragraph" }
                   | list                { puts "REDUCE list" }

    # Headers: Matches # or ## or ### followed by text
    header          : "#"           text
                   | "##"          text
                   | "###"         text

    # Paragraph: A sequence of non-newline characters
    paragraph       : TEXT

    # Lists: Items that start with a hyphen followed by text
    list            : list_item
                   | list list_item

    list_item       : "-" TEXT

    text : TEXT
end
