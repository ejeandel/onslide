# onslide

A  Quarto extension to make revealjs fragments easier to use


## Installation

To install this extension:

```
quarto add ejeandel/onslide
```

## Usage

Only works for revealjs 

```
---
title: example
filters: 
  - onslide
---


on all slides

:::{.onslide slides="1-2"}
only in slides 1 and 2
:::

:::{.onslide slides="2-3"}
only from slide 2  to 3
:::

```
