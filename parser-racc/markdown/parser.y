##
## to compile use
##    $ racc -o parser.rb parser.y


class MarkdownParser
  rule
    # Document rule can have zero or more elements
    document        : element_list

    # element_list can be empty or have multiple elements
    element_list    :               # Empty rule allows no elements
                   | element_list element  # Or one or more elements

    # Elements can still be headers, paragraphs, or lists
    element         : header
                   | paragraph
                   | list

    # Headers rule as before
    header          : "#" text
                   | "##" text
                   | "###" text

    # Paragraphs
    paragraph       : TEXT

    # Lists
    list            : list_item
                   | list list_item

    list_item       : "-" TEXT

    # Handling text (no changes here)
    # TEXT            : /[^\n]+/
end

