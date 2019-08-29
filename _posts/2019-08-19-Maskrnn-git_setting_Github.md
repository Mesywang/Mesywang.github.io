---
layout: post
title: "FB-Maskrnn_demo测试+加快Github网页访问速度"
subtitle: 'Using Vim with non-english input method'
author: "xudongdong"
header-style: text
tags:
  - Maskrnn
  - Deep learning
  - Object detection
---

# 0、前言
> 师兄的fast程序我怎么都跑不明白？好奇怪地说。既然也是从ctrl+cv闯出来的，那就从github down源码调试一下～<br> 期间突然想给git加个代理clone速度会快一点～还行，不过是崩了俩小时..

# 1、提高Github[网页]访问速度
- Github的网站访问受到墙的影响访问速度一直感人，特别是前一阵子还没有再本地配置jekyll环境的时候，改一点内容都要等半天..今天下午也是查了不少bolg，兄弟们给的建议出奇的一致，这时候我忘记了师兄跟我说过的能google就google的忠告= =

- 1.登录[http://tool.chinaz.com/dns/](http://tool.chinaz.com/dns/)
- 2.查询以下三个域名映射 选择响应时间短的这样放好

```coq
13.229.188.59   github.com  
185.199.108.153 assets-cdn.github.com  
67.228.235.91   github.global.ssl.fastly.net 
```

- 3.将查询到的ip和域名设置到host中

```coq
sudo vim /etc/hosts
```
打开后把上面三行粘贴进去(vim编辑保存指令记得背哦)
- 4.Esc--->:wq保存后重启网络

```coq
/etc/init.d/networking restart
```

### 搞定 好像快了那么一点？？可能是幻觉

### 这里我不说怎么加快git clone的速度.. 我教你盲目设置代理之后怎么恢复原来的能用状态..
- 哦嚯如果你执行了下面这个

```coq
git config --global http.proxy http://127.0.0.1:X
```
- 不要慌，你可能git clone都用不了，报这个错：Failed to connect to 127.0.0.1 port 1080 : Connectionrefused 如果CSDN实在找不到解决办法了..

> [Stackoverflow大法好](https://stackoverflow.com/questions/24543372/git-cannot-clone-or-push-failed-to-connect-connection-refused)  无助了两个小时，卸了git又装了一遍还不行，下面指令救了我

```coq
git config --global -l
cd ~/
vim .gitconfig
```
- 删掉`http.proxy http://127.0.0.1:X` 这些内容立马见效～

---------------------------

# 2、FB开源的`Maskrcnn物体检测`源码demo测试

- 说实话嗷~~一个demo我跑了一上午搞得又晕又委屈.. 本来一步步写指令我就能安装好依赖，写了那么多readme install……就想让人看不懂是不= =

- 现在做的项目是教室内表情识别(左边从上往下第三个框框)

<img src="/img/190816post/liuchengtu.jpg" width="0" height="0" />

- 所以想要先把脸切出来肯定需要定位图片中的所有小朋友是吧，效果怎么样！

<img src="/img/190819post/stu.jpg" width="0" height="0" />

#### 8.19 22:35 溜了溜了..明天看看怎么切
<br>
# 后续
## 8.20一上午把demo调好可以用了 nice～ 
- 流程图里面的4、5步已经配置好，拿47分钟/一个半小时的视频来测试<br>

| step1图片 | step2图片 | step3图片 |
| :----: | :----: |:----:|
| 2876张/0.25h | 261810张/1.5h | 76000+张/3h+ |
|  6800张/1h | 524100张/3h  | 130000张/7h+  |


- 还行，跑了一晚上愣是没跑完= = 关于提速我有两点强调一下：
1. 教室内摄像头所拍摄的视频截图的时候`间隔时间可以大一点`，同学们一般动作变化不大，能有效`减少重复`图片。
2. 使用两个卡跑(废话...)   关键是终端直接用就可以了 $CUDA_VISIBLE_DEVICES=O/1 python3 main.py

- GTX1080Ti×2 对50w张图片进行人脸检测并调整脸部图片大小至224×224 稳定显存 5605/11175MiB 8516/11178MiB 这速度，这感觉，效果杠杠的啊，后面剩下的视频几十个小时就弄完了..

> 瞅瞅瞅瞅↓ $watch -n 0.1 nvidia-smi

<img src="/img/190819post/nvidia-state.png">
> 瞅瞅瞅瞅↑

<img src="/img/190819post/xinglexingle.jpg" >

## 还不行！我还要说！

昨晚体验了一把ssh+tmux控制，效果图如下，贼爽～～

<img src="/img/190819post/ssh-cutface_for_datasets.png" >

> Vim 炒鸡好用指令推荐：`Ctrl+S` 谁用谁说好 :)

> 离实习结束还有`8天`，Github上FB还有个`Pytext`项目，clone下来明天搞搞

我仔细想了想，觉得以后都不一定有机会摸环境都配置好而且配置这么棒的电脑..跟着FB的步骤来玩玩看
[FB官方教程](https://pytext.readthedocs.io/en/master/train_your_first_model.html)

坏消息..装了一下午依赖有点小失败..貌似不会更新了= =抱歉

## 参考文档
- [Github-facebookresearch/maskrcnn](https://github.com/facebookresearch/maskrcnn-benchmark)
- [有ssh准备搞得同学就自己试试啦～](https://www.cnblogs.com/JarvisCJ/p/8395569.html)


