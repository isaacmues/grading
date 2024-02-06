# Grading

Templates and scripts for grading homeworks

## How it works

The LuaTeX template and consists of two parts.
The `preamble.tex`, which contains the Lua code and some useful macros.
And the `template.tex`, which is designed to be copied for each work of the
students. There sould also be a csv file cotaining the names of the students.

First copy the `template.tex` to `grades/wn-students-name.tex`.
Here `w` can be `t`, for homeworks, or `e` for exams and `n` refers to the
number can go from `01` to `99`.

To add the score for each exercise use the macro `\point{f}` where `f` is
should go from 0.0 to 1.0. The macro can take a second argument `w` to change
the weight of the score. For example, to make the score be the double of 1.0
the macro is written `\point[2.0]{1.0}`.

The compilation is done using the following command:

```
latexmk -pdf -pdflatex=lualatex file.tex
```
