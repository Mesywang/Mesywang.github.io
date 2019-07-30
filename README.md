# The Jekyll Template for Cotes' Blog

[![Build Status](https://travis-ci.org/cotes2020/cotes-blog.svg?branch=master)](https://travis-ci.org/cotes2020/cotes-blog)
[![GitHub release](https://img.shields.io/github/release/cotes2020/cotes-blog.svg)](https://github.com/cotes2020/cotes-blog/releases)
[![GitHub license](https://img.shields.io/github/license/cotes2020/cotes-blog.svg)](https://github.com/cotes2020/cotes-blog/blob/master/LICENSE)
[![996.icu](https://img.shields.io/badge/link-996.icu-red.svg)](https://996.icu)

A Jekyll template with responsive web design is also the framework of my personal blog, deployed in: [https://blog.cotes.info](https://blog.cotes.info).

## Features

* Last modified date
* Table of Contents
* Disqus Comments
* Syntax highlighting
* Two Level Categories
* Search
* Support dual language (en-US & zh-CN)
* HTML compress
* RSS Feed
* Google Analytics
* Pageviews (Advanced)

## Configuration

Go to the repository root and check the following files in `_data`:

* meta.yml
* profile.yml
* settins.yml

Change the value of fields to your own.


## Writing

There are a few things you should know about writing a blog post.

### Table of Contents

By default, the **T**able **o**f **C**ontents (TOC) is displayed on the right panel of the post. If you want to turn it off globally, go to `_data/settings.yml` and set the variable `toc` to `false`. If you want to turn off TOC in a separate post, add the following to post's [Front Matter](https://jekyllrb.com/docs/front-matter/):

```yaml
---
toc: false
---
```


### Comments

Similar to TOC, the [Disqus](https://disqus.com/) comments is loaded by default in each post, and the global switch is defined by variable `comments` in file `_data/settings.yml` . If you want to close the comment module of a post separately, add the following to the **Front Matter** of the post:

```yaml
---
comments: false
---
```


### Categories and Tags

The pages for all the categories and tags are placed in the `categoreis` and `tags` respectively.

Let's say there is a post with title `The Beautify Rose`, it's Front Matter as follow:

```yaml
---
title: "The Beautify Rose"
categories: [Plant]
tags: [flower]

 ...

---
```

> **Note**: `categories` is designed to contain up to two elements.

Now you need to create two files for `categories` and `tags`:

Step 1. Create **Category** file `categories/Plant.html` and fill:

```yaml
---
layout: category
title: Plant        # The title of category page.
category: Plant     # The category name in post
---
```

Step 2. Create **Tag** file `tags/flower.html` and fill:

```yaml
---
layout: tag
title: Flower       # The title of tag page.
tag: flower         # The tag name in post.
---
```

If you find this to be time consuming, please use the script tool `pages_generator.py` that placed in `_scripts/tools/`.

The python script needs [ruamel.yaml](https://pypi.org/project/ruamel.yaml/), make sure it's installed in your environment. Now run the tool:

```bash
python _scripts/tools/pages_generator.py
```

Few seconds later, it will create the Categoreis and Tags HTML files automatically.

## Getting Start

### Install the Jekyll Plugins

Please execute the following command in the root of the repository.

```bash
bundle install
```

`bundle` will install all dependent Jekyll Plugins declared in `Gemfile` that stored in the root automatically.

### Complete your site

Run the following script after the posts changes are commited:

```bash
python _scripts/tools/init_all.py
```
> **Note**: This step is required before EACH build or run of your site.

The script `init_all.py` (depends on [ruamel.yaml](https://pypi.org/project/ruamel.yaml/)) will create HTML pages for all Categories and Tags, and update the Last Modified Date of posts.



### Run Locally

```bash
bundle exec jekyll serve
```

Open your brower and visit `http://127.0.0.1:4000`.

### Publish to GitHub Pages

For security reasons, **GitHub Pages** runs on `safe` mode, which means the third-party Jekyll plugins (e.g. `jekyll-timeago`) doesn't work, so we have to build locally rather than on GitHub.

There are two basic types of GitHub Pages sites, so you can choose one of them.

#### User and Organization Pages sites


Step 1. Build your site:

```bash
JEKYLL_ENV=production bundle exec jekyll build
```
The build results will be stored in `_site` of your repository.

Step 2. Go to GitHub and create a new repository named `<username>.github.io`.

Step 3. Copy the build results mentioned in **Step 1** to the new repository.

Step 4. On GitHub, enable Pages service for the new repository.

Step 5. Visit `https://<username>.github.io` and enjoy.

#### Project Pages sites

If you want to put the source code and build results in one repository, the **Project Pages sites** is for you.

> **Note**: Do NOT rename your repository to `<username>.github.io` !

Step 1. Build project locally and store output to `docs` in the root of repository:

```bash
JEKYLL_ENV=production bundle exec jekyll build -d docs
```

Step 2. Git commit and push the changes of `docs` to GitHub.

Step 3. Go to GitHub and [set up with your project
](https://help.github.com/en/articles/configuring-a-publishing-source-for-github-pages#publishing-your-github-pages-site-from-a-docs-folder-on-your-master-branch).

Step 4. Now your site is published at `https://<username>.github.io/<project>/`

