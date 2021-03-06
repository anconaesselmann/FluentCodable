//  Created by Axel Ancona Esselmann on 8/16/21.
//

import Foundation

public extension Data {

    enum EncodingError: Error {
        case couldNotTurnDataIntoUtf8String
    }

    enum Presets {
        case none
        case server
    }

    struct DecodingFluentHelper<T> where T: Decodable {
        fileprivate let decoder: JSONDecoder
        fileprivate let data: Data
        fileprivate let keyDecodingStrategy:  JSONDecoder.KeyDecodingStrategy
        fileprivate let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy

        public func keyDecodingStrategy(_ keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) -> Self {
            return .init(
                decoder: decoder,
                data: data,
                keyDecodingStrategy: keyDecodingStrategy,
                dateDecodingStrategy: dateDecodingStrategy
            )
        }

        public func dateDecodingStrategy(_ dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) -> Self {
            return .init(
                decoder: decoder,
                data: data,
                keyDecodingStrategy: keyDecodingStrategy,
                dateDecodingStrategy: dateDecodingStrategy
            )
        }

        public func decoded() throws -> T {
            decoder.keyDecodingStrategy = keyDecodingStrategy
            decoder.dateDecodingStrategy = dateDecodingStrategy

            return try decoder.decode(T.self, from: data)
        }
    }

    /**
     Decodes a JSON string to the infered "Decoded".

     An optional "preset" parameter can be passed in for controlling the decoding behaviour

     - Parameters:
        - presets: .server or .none: If no perset is passed into decoded() the .server preset
            will be used. Property names get decoded from snake_case to camelCase and date-stings
            are assumed to conform toISO 8601. Example date string: "2050-01-01T00:00:01".
            Find out more about ISO 8601: https://en.wikipedia.org/wiki/ISO_8601). If .none is
            passed in the default behaviour for json decoding will be used: property names will
            stay unchanged and Date's default encoding will be used.
        - decoder: Pass in a JSONDecoder to re-use it.
             NOTE: depending on the preset passed in the, decoder's settings will get changed.

     - Returns: A `Decoded` instance.
     */
    func decoded<T>(
        _ presets: Presets = .server,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> T where T: Decodable {
        switch presets {
        case .none:
            return try DecodingFluentHelper(
                decoder: decoder,
                data: self,
                keyDecodingStrategy: .useDefaultKeys,
                dateDecodingStrategy: .deferredToDate
            ).decoded()
        case .server:
            return try DecodingFluentHelper(
                decoder: decoder,
                data: self,
                keyDecodingStrategy: .convertFromSnakeCase,
                dateDecodingStrategy: .iso8601
            ).decoded()
        }
    }

    struct EncodingFluentHelper<T> where T: Encodable {
        fileprivate let encoder: JSONEncoder
        fileprivate let encodable: T
        fileprivate let keyEncodingStrategy:  JSONEncoder.KeyEncodingStrategy
        fileprivate let dateEncodingStrategy: JSONEncoder.DateEncodingStrategy
        fileprivate let outputFormatting: JSONEncoder.OutputFormatting

        public func keyEncodingStrategy(_ keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy) -> Self {
            .init(
                encoder: encoder,
                encodable: encodable,
                keyEncodingStrategy: keyEncodingStrategy,
                dateEncodingStrategy: dateEncodingStrategy,
                outputFormatting: outputFormatting
            )
        }

        public func dateEncodingStrategy(_ dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) -> Self {
            .init(
                encoder: encoder,
                encodable: encodable,
                keyEncodingStrategy: keyEncodingStrategy,
                dateEncodingStrategy: dateEncodingStrategy,
                outputFormatting: outputFormatting
            )
        }

        public func outputFormatting(_ outputFormatting: JSONEncoder.OutputFormatting) -> Self {
            .init(
                encoder: encoder,
                encodable: encodable,
                keyEncodingStrategy: keyEncodingStrategy,
                dateEncodingStrategy: dateEncodingStrategy,
                outputFormatting: outputFormatting
            )
        }

        public func asData() throws -> Data {
            encoder.outputFormatting     = outputFormatting
            encoder.dateEncodingStrategy = dateEncodingStrategy
            encoder.keyEncodingStrategy  = keyEncodingStrategy

            return try encoder.encode(encodable)
        }
    }

    func json<T>(using decoder: JSONDecoder = JSONDecoder()) -> DecodingFluentHelper<T> {
        DecodingFluentHelper(
            decoder: decoder,
            data: self,
            keyDecodingStrategy: .useDefaultKeys,
            dateDecodingStrategy: .deferredToDate
        )
    }

    func asString(encoding: String.Encoding = .utf8) throws -> String {
        if let encodedString = String(data: self, encoding: encoding) {
            return encodedString
        } else {
            throw Data.EncodingError.couldNotTurnDataIntoUtf8String
        }
    }
}

public extension Encodable {

    func json(using encoder: JSONEncoder = JSONEncoder()) -> Data.EncodingFluentHelper<Self> {
        Data.EncodingFluentHelper(
            encoder: encoder,
            encodable: self,
            keyEncodingStrategy: .useDefaultKeys,
            dateEncodingStrategy: .deferredToDate,
            outputFormatting: []
        )
    }

    func asData(
        _ presets: Data.Presets = .server,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> Data {
        switch presets {
        case .none:
            return try Data.EncodingFluentHelper(
                encoder: encoder,
                encodable: self,
                keyEncodingStrategy: .useDefaultKeys,
                dateEncodingStrategy: .deferredToDate,
                outputFormatting: []
            ).asData()
        case .server:
            return try Data.EncodingFluentHelper(
                encoder: encoder,
                encodable: self,
                keyEncodingStrategy: .convertToSnakeCase,
                dateEncodingStrategy: .iso8601,
                outputFormatting: []
            ).asData()
        }
    }

    func asString(
        _ presets: Data.Presets = .server,
        encoder: JSONEncoder = JSONEncoder()
    ) throws -> String {
        let asData = try asData(presets, encoder: encoder)
        return try asData.asString()
    }
}

public extension String {
    func data() -> Data{
        Data(utf8)
    }

    func json<T>(using decoder: JSONDecoder = JSONDecoder()) -> Data.DecodingFluentHelper<T> {
        data().json(using: decoder)
    }

    /**
     Decodes a JSON string to the infered "Decoded".

     An optional "preset" parameter can be passed in for controlling the decoding behaviour

     - Parameters:
        - presets: .server or .none: If no perset is passed into decoded() the .server preset
            will be used. Property names get decoded from snake_case to camelCase and date-stings
            are assumed to conform toISO 8601. Example date string: "2050-01-01T00:00:01".
            Find out more about ISO 8601: https://en.wikipedia.org/wiki/ISO_8601). If .none is
            passed in the default behaviour for json decoding will be used: property names will
            stay unchanged and Date's default encoding will be used.
        - decoder: Pass in a JSONDecoder to re-use it.
             NOTE: depending on the preset passed in the, decoder's settings will get changed.

     - Returns: A `Decoded` instance.
     */
    func decoded<Decoded>(
        _ presets: Data.Presets = .server,
        decoder: JSONDecoder = JSONDecoder()
    ) throws -> Decoded where Decoded: Decodable {
        try Data(utf8).decoded(presets, decoder: decoder)
    }
}


// "asData()" does the reverse , it encodes an Encodable type using the
// has an equivalent optional preset:
