# 3D Printed Lamp Model

OpenSCAD file for printing your very own customizable 3D printed lamp frame

![Lamp](http://josephstein.com/wp-content/uploads/2017/08/lamp.jpg "Lamp")

## Overview

This lamp incorporates the use of wood dowels with 3D printed joints to hold it all together. 

A lot of the properties are customizable so depending on what dowel diameters you use, all you need to do is enter the correct value into the properties listed at the top of the file.

A lot of the properties (listed below) are optional but included so you have the freedom to change things and make the lamp look drastically different.

When you run the file, it'll output the exact lengths of all the dowels so there's no guess work needed.

Unfortunately I wasn't able to fully finish the product (I never got to printing the top center piece) as I was using my previous office's printer which I no longer have access to.

## Properties

I hope they're (somewhat?) self-explanatory :)

```
kPlatformWidthBase = 210;
kPlatformWidthTop = kPlatformWidthBase - 40;
kPlatformWidthBottom = kPlatformWidthBase - 60;

kCordDiameter = 6.27;
kCordBaseDiameter = 14.58;
kCordBasePadding = 7.0;

kDowelDiameter = 11.1125;
kDowelSleeveLength = 40;
kDowelSleeveTopLength = 45;
kDowelSleevePadding = 3.5;
kDowelFoundationLength = 19.0;
kDowelFoundationTopLength = 34.0;

kEndCapDiameter = kDowelDiameter + kDowelSleevePadding*1.5;

kLightbulbSocketDiameter = 39.69;
kLightbulbSocketLength = 58.74;

kLightbulbSocketNippleLength = 15.87;
kLightbulbSocketNippleDiameter =  12.0;

kLightbulbLength = 139.7;
kLightbulbDiameter = 25.57;

kTotalHeight = 350.0;
kTopToBottomHeightRatio = 0.6;

kZIndexBase = 0;
kZIndexTop = kTotalHeight * kTopToBottomHeightRatio;
kZIndexBottom = -(kTotalHeight * (1 - kTopToBottomHeightRatio));
```

## Tag me!

I'd love to see what you've done! Please be sure to reach out to me and if I love it I'll be sure to include it in a showcase I'll display in the future here.

Email: [josephstein@me.com](mailto:josephstein@me.com)  
Instagram: [@josephstein](https://www.instagram.com/josephstein)


