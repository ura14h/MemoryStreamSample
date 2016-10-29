//
//  BytePackerImplements.swift
//  MemoryStreamSample
//
//  Created by Hiroki Ishiura on 2016/10/29.
//  Copyright © 2016年 Hiroki Ishiura. All rights reserved.
//

import Foundation

extension UInt8 {
	
	init?(bytes: [UInt8]) {
		guard let value: UInt8 = convertBytesToValue(bytes: bytes) else {
			return nil
		}
		self = value
	}
	
	func bytes() -> [UInt8] {
		return convertValueToBytes(value: self)
	}
	
}

extension UInt16 {
	
	init?(bytes: [UInt8]) {
		guard let value: UInt16 = convertBytesToValue(bytes: bytes) else {
			return nil
		}
		self = value
	}
	
	func bytes() -> [UInt8] {
		return convertValueToBytes(value: self)
	}
	
}

extension UInt32 {
	
	init?(bytes: [UInt8]) {
		guard let value: UInt32 = convertBytesToValue(bytes: bytes) else {
			return nil
		}
		self = value
	}
	
	func bytes() -> [UInt8] {
		return convertValueToBytes(value: self)
	}
	
}

extension UInt64 {
	
	init?(bytes: [UInt8]) {
		guard let value: UInt64 = convertBytesToValue(bytes: bytes) else {
			return nil
		}
		self = value
	}
	
	func bytes() -> [UInt8] {
		return convertValueToBytes(value: self)
	}
	
}

extension String {

	init?(bytes: [UInt8]) {
		let data = Data(bytes: bytes)
		guard let value = String(data: data, encoding: .utf8) else {
			return nil
		}
		self = value
	}
	
	func bytes() -> [UInt8] {
		let bytes = [UInt8](self.utf8)
		return bytes
	}

}

extension Data {
	
	func bytes() -> [UInt8] {
		let bytes = withUnsafeBytes {
			[UInt8](UnsafeBufferPointer(start: $0, count: count))
		}
		return bytes
	}

}

// MARK: -

fileprivate func convertBytesToValue<T>(bytes: [UInt8]) -> T? {
	if bytes.count < MemoryLayout<T>.size {
		return nil
	}
	let value = UnsafePointer(bytes).withMemoryRebound(to: T.self, capacity: 1) {
		$0.pointee
	}
	return value
}

fileprivate func convertValueToBytes<T>(value: T) -> [UInt8] {
	var mutableValue = value
	let bytes = Array<UInt8>(withUnsafeBytes(of: &mutableValue) {
		$0
	})
	return bytes
}

