YAUIKit
=======

YAUIKit 是一个复杂UI的实现库。其提供了多种复杂UI的实现和自定义。

## 添加到你的工程
#### 1.YAUIKit

将 `YAUIKit.xcodeproj` 图标拖拽到你的项目文件目录中。

#### 2.设置项目 Building Settings

点击 `项目` -> `(TARGETS)` 图标，在 `Build Settings` 里找到 `Other Linker Flags`, 设置为 `-ObjC`。

#### 3.设置目标 Building Settings

同上，找到 Header Search Paths，添加

* ../YAUIKit/YAUIKit/Library
* ../YAUIKit/YAUIKit/Source

#### 4.添加依赖

点击目标(TARGETS)图标，选择 `Building Phases`。

在 `Target Dependencies`，添加 `YAUIKit`。

在 `Link Binary with Libaries` 中，加入下列库 `libYAUIKit.a`

###### TIPS:

如果你的工程中还需要使用YAToolKit。那么请使用`YAUIKit(without YAToolKit)` Target.
