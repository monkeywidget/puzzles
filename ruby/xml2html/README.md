WordPress XML to HTML
=====================

Renders a WordPress XML Export as simple HTML

- Loads a WordPress XML Export  
- prints to a HTML document
- CSS-friendly for categories
- keeps only data from:
    - `<item>` - currently a `div`
        - `<title>` - currently a `h1`
        - `<pubDate>` - currently a `i`
        - `<content>` - currently a `div`
        - `<category>` (in CSS only)

The idea of this was to make a HTML render that would paste into a Word or Google document and retain similar roles of formatting.

To Customize
============

- your categories each have their own CSS class
- therefore if you wanted all posts in category "foo" to be blue, you would add to the CSS:

      .foo {
          background-color: lightblue;
      }
