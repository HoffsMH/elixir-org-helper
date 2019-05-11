# Org mode files helper
Combines some helper functions that make it easier to manage my implementation of [GTD](https://www.amazon.com/Getting-Things-Done-Stress-Free-Productivity/dp/0143126563)

## Features:
- *project list groomer:*
  Every time org is run it will get a list of all active projects in projects folder and create a project list.
   It will not overwrite any notes written under and existing projects and will help you retire

- *batch filename prepender*
  Allows you to prepend strings in batch to a list of files. This is useful when applying dates to
  many files according to when you acquired them. eg

  ```sh
  some_document.pdf
  some_document2.pdf
  some_document3.pdf
  some_documen4.pdf
  ```
  after

  ```sh
  org file prepend 2019-07-04- *.pdf
  ```

  turns into

  ```sh
  2019-07-04-some_document.pdf
  2019-07-04-some_document2.pdf
  2019-07-04-some_document3.pdf
  2019-07-04-some_documen4.pdf
  ```
  as opposed to using `mv` or finder to do each one individually

- *batch filename un-prepender*
  in order to edit prefixes easily from previous prepender feature

- *capture*
  a stripped down version of org capture from emacs
  I spend a good amount of time in the command line. If a thought occurs to me that I would like to send to my capture file quickly I can so from any command line I can use

  ```sh
  org cap "out of coffee filters!"
  ```

## To build:

  ```
  mix escript.build
  ```


## Tests:

```
mix tests
```
