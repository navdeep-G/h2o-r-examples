# H2O R Examples

## Setting Up Environment for H2O:

### Prerequisites for H2O

[H2O-3 Requirements](http://h2o-release.s3.amazonaws.com/h2o/rel-wright/2/docs-website/h2o-docs/welcome.html#requirements)

### Install H2O in R
```
# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
pkgs <- c("RCurl","jsonlite")
for (pkg in pkgs) {
if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-wright/2/R")
```

### Repo Overview

* [Overview of H2O-3](https://github.com/navdeep-G/h2o-r-examples/blob/master/h2o.pdf)