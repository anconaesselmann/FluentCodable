import Foundation
import FluentCodable

struct CatMeme: Codable {
    let id: Int
    let title: String
    let firstPosted: Date
}

// Memes on servers:
var nyanCatJsonString = #"{"id":5,"title":"Nyan Cat","first_posted":"2011-04-05T12:00:01Z"}"#

// Strings to memes:
var nyanCat = try nyanCatJsonString
    .decoded() as CatMeme

// Memes to data:
let nyanCatData = try nyanCat.asData()

// Data to strings:
let nyanCatString = try nyanCat.asString()

// Data to memes:
nyanCat = try nyanCatData.decoded()


// More memes on strange servers:
var grumpyCatJsonString = #"{"id":5,"title":"Grumpy Cat","firstPosted":323697601}"#

// Strings to memes:
var grumpyCat = try grumpyCatJsonString
    .decoded(.none) as CatMeme

// Memes to data:
let grumpyCatData = try grumpyCat.asData(.none)

// Data to strings:
let grumpyCatString = try grumpyCat.asString(.none)

// Data to memes:
grumpyCat = try grumpyCatData.decoded(.none)

// CAN I HAS ALL THE CONTROL???
let decoder = JSONDecoder()
let encoder = JSONEncoder()
var inbreadCatJsonString = #"{"id":5,"title":"Inbread Cat","first_posted":323697601}"#

// Strings to memes:
var inbreadCat: CatMeme = try inbreadCatJsonString
    .json(using: decoder)
    .keyDecodingStrategy(.convertFromSnakeCase)
    .dateDecodingStrategy(.secondsSince1970)
    .decoded()

// Memes to data:
let inbreadCatData = try inbreadCat
    .json(using: encoder)
    .keyEncodingStrategy(.useDefaultKeys)
    .dateEncodingStrategy(.deferredToDate)
    .outputFormatting([.prettyPrinted, .sortedKeys])
    .asData()

// Back to memes:
inbreadCat = try inbreadCatData
    .json(using: decoder)
    .dateDecodingStrategy(.deferredToDate)
    .keyDecodingStrategy(.useDefaultKeys)
    .decoded()
