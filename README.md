# SPMGen

Code generator for Swift.

## Installation

### Homebrew

```bash
brew install edudo-inc/formulae/spmgen
```

### Makefile

```bash
# Download repo
git clone https://github.com/edudo-inc/spmgen.git

# Navigate to repo directory
cd spmgen

# Build and install using Make
make install

# You can also delete spmgen using `make uninstall` command
```

## Resources command

SPMGen provides static resource factories for various resource types.

Supported resources:

| Resource           | Extensions        | Is reliable |
| ------------------ | ----------------- | ----------- |
| ColorResource      | `.xcassets`       | true        |
| FontResource       | `.ttf` `.otf`     | true        |
| ImageResource      | `.xcassets`       | true        |
| NibResource        | `.xib`            | not used    |
| StoryboardResource | `.storyboard`     | not used    |
| SCNSceneResource   | `.scnassets/.scn` | true        |

### Integration

Add SPMGen dependency to your package

```swift
.package(url: "https://github.com/edudo-inc/spmgen.git", from: "1.0.1")
```

Create `<#Project#>Resources` target with a following structure

```plaintext
Sources
  <#Project#>Resources
    Resources
      <#Assets#>
```

Specify resource processing and add SPMResources dependency to your target

```swift
.target(
  name: "<#Project#>Resources",
  dependencies: [
    .product(
      name: "SPMResources",
      package: "spmgen"
    )
  ],
  resources: [
    .process("Resources")
  ]
)
```

Add a script to your `Run Script` target build phases

```bash
spmgen resources "$SRCROOT/Sources/<#Project#>Resources/Resources" \
  --output "$SRCROOT/Sources/<#Project#>Resources/SPMGen.swift" \
  --indentor " " \
  --indentation-width 2

# You can also add `--disable-exports` flag to disable `@_exported` attribute
# for `import SPMResources` declaration in generated file
```

Add `<#Project#>Resources` target as a dependency to other targets

```swift
.target(
  name: "<#Project#>Module",
  dependencies: [
    .target(name: "<#Project#>Resources")
  ]
)
```

### Usage

Import your `<#Project#>Resources` package and initialize objects using `.resource()` static factory

```swift
import <#Project#>Resources
import UIKit

let label = UILabel()
label.backgroundColor = .resource(.accentColor)
label.textColor = .resource(.primaryText)
label.font = .primary(ofSize: 12, weight: .semibold, style: .italic)

let imageView = UIImageView(image: .resource(.logo))
```

> **Note: Fonts require additional setup**
>
> For example you want to add `Monsterrat` and `Arimo` fonts with different styles
>
> - Download fonts and add them to `Sources/<#Project#>Resources/Resources` folder
>
> - Add a static factories for your custom fonts (_[Example](https://gist.github.com/maximkrouk/5bcccc5db12f0347676be5a776c309a8)_)
> - Register custom fonts on app launch (_in AppDelegate, for example_) 
>   - `UIFont.bootstrap()` if you are using code from the example above.



## CasePaths command

Generate CasePaths for all enums in your project using following command

```bash
spmgen casepaths "<path_to_sources>" \
  --indentor " " \
  --indentation-width 2
```

> **Todo:** Support configuration file with exclude paths and typename-based excludes.