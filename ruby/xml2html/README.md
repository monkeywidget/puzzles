WordPress XML to HTML
=====================

Renders a WordPress XML Export as simple HTML

- Loads a WordPress XML Export  
- prints to a HTML document
- CSS-friendly for categories
- keeps only data from:
    - `<item>`
        - `<title>`
        - `<pubDate>`
        - `<content>`
        - `<category>` (in CSS only)

To Customize
============

- your categories each have their own CSS class
- therefore if you wanted all posts in category "foo" to be blue, you would add to the CSS:

      .foo {
          background-color: lightblue;
      }
