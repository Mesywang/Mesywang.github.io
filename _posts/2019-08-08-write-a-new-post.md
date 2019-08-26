---
title: "Write a new Post"
date: 2019-08-08 14:10:00 +0800
categories: [Blogging, Tutorial]
tags: [writting]
---

## Naming and Path

Create a new file name with the format `YYYY-MM-DD-title.md` then put it into `_post` of the root directory.

## Front Matter

Basically, you need to fill the [Front Matter](https://jekyllrb.com/docs/front-matter/) as below at the top of the post:

```yaml
---
title: TITLE
date: YYYY-MM-DD HH:MM:SS +/-TTTT
categories: [TOP_CATEGORIE, SUB_CATEGORIE]
tags: [TAG]
---
```

> **Note**: The posts' ***layout*** has been set to `post` by default, so there is no need to add the variable ***layout*** in Front Matter block.

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

Beause it's time consuming, so use the script tool `pages_generator.py` that placed in `_scripts/tools/`.

The python script needs [ruamel.yaml](https://pypi.org/project/ruamel.yaml/), make sure it's installed in your environment. Now run the tool:

```bash
python _scripts/tools/pages_generator.py
```

Few seconds later, it will create all the Categoreis and Tags HTML files automatically.

### Last Modified Date

The last modified date of a post is basic on it's last git commit date.

Run the following tool (depends on [ruamel.yaml](https://pypi.org/project/ruamel.yaml/)):

```shell
python _scripts/tools/update_posts_lastmod.py
```

It will create the variable `lastmod` that stored the latest modified date in the font matter block of a post.

## Table of Contents

By default, the **T**able **o**f **C**ontents (TOC) is displayed on the right panel of the post. If you want to turn it off globally, go to `_data/settings.yml` and set the variable `toc` to `false`. If you want to turn off TOC for specific post, add the following to post's [Front Matter](https://jekyllrb.com/docs/front-matter/):

```yaml
---
toc: false
---
```


## Comments

Similar to TOC, the [Disqus](https://disqus.com/) comments is loaded by default in each post, and the global switch is defined by variable `comments` in file `_data/settings.yml` . If you want to close the comment for specific post, add the following to the **Front Matter** of the post:

```yaml
---
comments: false
---
```


## Learn More
For more knowledge about writting, visit the [Jekyll Docs: Posts](https://jekyllrb.com/docs/posts/).

