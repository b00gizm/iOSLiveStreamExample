iOSLiveStreamExample
====================

Work in progress!
-----------------

__As of today, it's a WIP and not fully functional__. I'm still trying to wrap my head around the topic. Help, expertise and contribution is appreactiated.

Motivation
----------

Here's the thing: We want to establish a H264/AAC live stream from our iOS device to some arbitrary server over RTMP. Easy enough, right? Well... not so much.

Before iOS 8, there wasn't even a way to use the hardware encoder without writing into a file via `AVAssetWriter`. So, your only options were to either find a way to simultaneously and efficiently read and write from and to many temp files, or to use some 3rd party software encoders, which are pretty good in delivering bad frame rates while burning through your device's battery.

That whole situation changed with iOS 8 and the introduction of the `VideoToolbox` framework for iOS which gives you direct access to your device's hardware de- and encoders. So, this is good news. The bad news is, that there's almost no documentation. Well, almost none:

> Video Toolbox (`VideoToolbox.framework`). The Video Toolbox framework comprises the 64-bit replacement for the QuickTime Image Compression Manager. Video Toolbox provide services for video compression and decompression, and for conversion between raster image formats stored in Core Video pixel buffers.

Source: [OS X Media Layer](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/OSX_Technology_Overview/MediaLayer/MediaLayer.html) (try to find it without CMD-F)

Okay, there is indeed a pretty good, but mostly superficial [session from last year's WWDC](https://developer.apple.com/videos/wwdc/2014/), which gives at least some clues. Other than that, you're pretty much on your own.

![](http://cdn2.hubspot.net/hub/74005/file-827178624-jpg/images/i-have-no-idea-what-im-doing.jpg%3Ft%3D1426628465105)

So, I'd like to take this opportunity to familiarize myself with the whole topic on the other hand, and to provide a sample project with a (hopefully) simple enough code base for other people desperately looking for clues (like me).  

![](http://imgs.xkcd.com/comics/wisdom_of_the_ancients.png)

([https://xkcd.com/979/](https://xkcd.com/979/))

Maintainer
----------

Pascal Cremer

* Email: <hello@codenugget.co>
* Twitter: [@b00gizm](https://twitter.com/b00gizm)
* Web: [http://codenugget.co](http://codenugget.co)

License
-------

>The MIT License (MIT)
>
>Copyright (c) 2014-2015 Pascal Cremer
>
>Permission is hereby granted, free of charge, to any person obtaining a copy
>of this software and associated documentation files (the "Software"), to deal
>in the Software without restriction, including without limitation the rights
>to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>copies of the Software, and to permit persons to whom the Software is
>furnished to do so, subject to the following conditions:
>
>The above copyright notice and this permission notice shall be included in all
>copies or substantial portions of the Software.
>
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
