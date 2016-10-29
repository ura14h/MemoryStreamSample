//
//  MemoryStream.swift
//  MemoryStreamSample
//
//  Created by Hiroki Ishiura on 2016/10/29.
//  Copyright © 2016年 Hiroki Ishiura. All rights reserved.
//

import Foundation

class MemoryInputStream {

	enum StreamError: Error {
		case insufficiencyStreamData
		case unknownStringEncoding
		case unknownReason
	}
	
	// Subclass of InputStream does not work by NSInvalidArgumentException.
	// NSInvalidArgumentException says "-open only defined for abstract class."
	var stream: InputStream!
	
	var streamDataLength: Int = 0
	
	init(data: Data) {
		stream = InputStream(data: data)
		streamDataLength = data.count
	}
	
	deinit {
	}

	func open() {
		stream.open()
	}
	
	func close() {
		stream.close()
	}
	
	func readInteger<T: BytePackedInteger>() throws -> T {
		let bytes = try readBytes(length: MemoryLayout<T>.size)
		guard let value = T(bytes: bytes) else {
			throw StreamError.insufficiencyStreamData
		}
		return value
	}
	
	func readString(length: Int = Int.max) throws -> String {
		let bytes = try readBytes(length: (length == Int.max) ? streamDataLength : length)
		guard let string = String(bytes: bytes) else {
			throw StreamError.unknownStringEncoding
		}
		return string
	}
	
	func readData(length: Int = Int.max) throws -> Data {
		let bytes = try readBytes(length: (length == Int.max) ? streamDataLength : length)
		let data = Data(bytes: bytes)
		return data
	}
	
	func readBytes(length: Int) throws -> [UInt8] {
		var readBuffer = [UInt8](repeating: 0, count: length)
		if streamDataLength < readBuffer.count {
			throw StreamError.insufficiencyStreamData
		}
		let readCount = try readStream(&readBuffer, maxLength: readBuffer.count)
		if readCount != readBuffer.count {
			throw StreamError.insufficiencyStreamData
		}
		return readBuffer
	}

	private func readStream(_ buffer: UnsafeMutablePointer<UInt8>, maxLength len: Int) throws -> Int {
		let readCount = stream.read(buffer, maxLength: len)
		if readCount > 0 {
			streamDataLength = streamDataLength - readCount
		} else if readCount == 0 {
			streamDataLength = 0
		} else {
			if let error = stream.streamError {
				throw error
			} else {
				throw StreamError.unknownReason
			}
		}
		return readCount
	}
	
}

// MARK: -

class MemoryOutputStream {
	
	enum StreamError: Error {
		case insufficiencyStreamCapacity
		case unknownStringEncoding
		case unknownReason
	}
	
	// Subclass of OutputStream does not work by NSInvalidArgumentException.
	// NSInvalidArgumentException says "-open only defined for abstract class."
	var stream: OutputStream!
	
	var streamDataLength: Int = 0

	init() {
		stream = OutputStream(toMemory: ())
	}
	
	deinit {
	}
	
	func open() {
		stream.open()
	}
	
	func close() {
		stream.close()
	}
	
	func write<T: BytePackedInteger>(integer: T) throws {
		let bytes = integer.bytes()
		try write(bytes: bytes, length: bytes.count)
	}
	
	func write(string: String, length: Int = Int.max) throws {
		let bytes = string.bytes()
		try write(bytes: bytes, length: (length == Int.max) ? bytes.count : length)
	}
	
	func write(data: Data, length: Int = Int.max) throws {
		let bytes = data.bytes()
		try write(bytes: bytes, length: (length == Int.max) ? bytes.count : length)
	}
	
	func write(bytes: [UInt8], length: Int) throws {
		let writeCount = try writeStream(bytes, maxLength: length)
		if writeCount != length {
			throw StreamError.insufficiencyStreamCapacity
		}
	}

	private func writeStream(_ buffer: UnsafePointer<UInt8>, maxLength len: Int) throws -> Int {
		let writeCount = stream.write(buffer, maxLength: len)
		if writeCount > 0 {
			streamDataLength = streamDataLength + writeCount
		} else if writeCount == 0 {
			throw StreamError.insufficiencyStreamCapacity
		} else {
			if let error = stream.streamError {
				throw error
			} else {
				throw StreamError.unknownReason
			}
		}
		return writeCount
	}
	
	func data() -> Data {
		return stream.property(forKey: Stream.PropertyKey.dataWrittenToMemoryStreamKey) as! Data
	}
	
}

// MARK: -

protocol BytePackedInteger {
	init?(bytes: [UInt8])
	func bytes() -> [UInt8]
}

extension UInt8:  BytePackedInteger { /* see BytePackerImplements.swift */ }
extension UInt16: BytePackedInteger { /* see BytePackerImplements.swift */ }
extension UInt32: BytePackedInteger { /* see BytePackerImplements.swift */ }
extension UInt64: BytePackedInteger { /* see BytePackerImplements.swift */ }
