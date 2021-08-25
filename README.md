# FluentCodable

[![CI Status](https://img.shields.io/travis/anconaesselmann/FluentCodable.svg?style=flat)](https://travis-ci.org/anconaesselmann/FluentCodable)
[![Version](https://img.shields.io/cocoapods/v/FluentCodable.svg?style=flat)](https://cocoapods.org/pods/FluentCodable)
[![License](https://img.shields.io/cocoapods/l/FluentCodable.svg?style=flat)](https://cocoapods.org/pods/FluentCodable)
[![Platform](https://img.shields.io/cocoapods/p/FluentCodable.svg?style=flat)](https://cocoapods.org/pods/FluentCodable)

FluentCodable is a [Fluent Interface](https://en.wikipedia.org/wiki/Fluent_interface) for encoding and decoding Codable types.

## Example

To run the example playground clone the repo, run `pod install` in the `Example` directory and open the `FluentCodableExample.xcworkspace` workspace. The `Example` playground (first element in the Project Navigator) contains all the examples from below.


### I Can Has Cat Memes?

Import the library
```swift
import FluentCodable
```
Make sure your meme conforms to `Codable` (or `Encodable`/`Decodable` if you only need to en/decode)

```swift
struct CatMeme: Codable {
    let id: Int
    let title: String
    let firstPosted: Date
}
````

Memes on servers:
```swift
let nyanCatJsonString = #"{"id":5,"title":"Nyan Cat","first_posted":"2011-04-05T12:00:01Z"}"#
````
Note: if those [hash marks](https://www.hackingwithswift.com/articles/162/how-to-use-raw-strings-in-swift) look funny to you, you are in luck! Your life just became a lot easier.

Strings to memes:
```swift
let nyanCat = try nyanCatJsonString
    .decoded() as CatMeme
```
Memes to data:
```swift
let nyanCatData = try nyanCat
    .asData()
```

Data to strings:
```swift
let nyanCatString = try nyanCat
    .asString()
```

Data to memes:
```swift
let nyanCat = try nyanCatData
    .decoded() as CatMeme
```

#### More memes on weird servers:
```swift
let grumpyCatJsonString = #"{"id":5,"title":"Grumpy Cat","firstPosted":323697601}"#
```

Strings to memes:
```swift
let grumpyCat = try grumpyCatJsonString
    .decoded(.none) as CatMeme
```

Memes to data:
```swift
let grumpyCatData = try grumpyCat
    .asData(.none)
```

Data to strings:
```swift
let grumpyCatString = try grumpyCat
    .asString(.none)
```

Data to memes:
```swift
let grumpyCat = try grumpyCatData
    .decoded(.none)
```

#### CAN I HAS ALL THE CONTROL???
```swift
let decoder = JSONDecoder()
let encoder = JSONEncoder()
let inbreadCatJsonString = #"{"id":5,"title":"Inbread Cat","first_posted":323697601}"#
```

Strings to memes:
```swift
let inbreadCat: CatMeme = try inbreadCatJsonString
    .json(using: decoder)
    .keyDecodingStrategy(.convertFromSnakeCase)
    .dateDecodingStrategy(.secondsSince1970)
    .decoded()
```

Memes to data:
```swift
let inbreadCatData = try inbreadCat
    .json(using: encoder)
    .keyEncodingStrategy(.useDefaultKeys)
    .dateEncodingStrategy(.deferredToDate)
    .outputFormatting([.prettyPrinted, .sortedKeys])
    .asData()
```

Back to memes:
```swift
let inbreadCat = try inbreadCatData
    .json(using: decoder)
    .keyDecodingStrategy(.useDefaultKeys)
    .dateDecodingStrategy(.deferredToDate)
    .decoded()
```

## Installation

FluentCodable is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FluentCodable'
```

## Author

anconaesselmann, axel@anconaesselmann.com

## License

FluentCodable is available under the MIT license. See the LICENSE file for more info.
