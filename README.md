# Grace Notes Website [![Build Status](https://travis-ci.org/grace-notes/website.svg?branch=master)](https://travis-ci.org/grace-notes/website)

This repository contains the content and build scripts for the topics library
on [Grace Notes](https://www.gracenotes.info).

It is planned to generate all of the studies on Grace Notes using this system.

## How it works

The topic library is composed of content files stored in the `contents/topics`
directory. Each [Markdown](https://pandoc.org/MANUAL.html) file is compiled
into an HTML file, a PDF and an ePub file. The topics list is generated as an
alphabetical list of each of the topics.

The site is generated primarily with a JavaScript static site generator called 
[wintersmith](https://github.com/jnordberg/wintersmith).

### Deployment

Each time a new file or modification is committed and pushed to the master
branch of this repository, a build system is triggered to regenerate the entire
site. The build script runs on 
[Travis CI](https://travis-ci.org/grace-notes/legacy-website). The build process
can take 20-30 minutes to complete. If there is an error during the build, the
build status icon displayed above will indicate that the build failed.

When a build passes, the files are then uploaded to an Amazon S3 Bucket wich is
configured to serve them as a static website.

#### Two deployment phases

The build and deployment are actually conducted in two phases. The first phase
compiles only the HTML version of he site in order to save time. After it is
uploaded, the PDF and ePub files are generated and uploaded. This allows changes
to be available on the site more quickly, while the PDF and ePub files may be
updated 10-20 minutes later.

## Development

Contributors should create a fork of this repository and submit their changes
as pull requests.

You may choose to edit files directly within the GitHub website. Alternately,
you may choose to edit files locally and use the `git` tool to commit them.
There are three primary advantages to using a local editor:

1. You may choose any local text editor according to your preference.

2. You can preview your changes locally by installing Wintersmith, Pandoc and
Latex.

3. You can group changes to multiple files into a single commit and/or pull
request if they are related to each other.





