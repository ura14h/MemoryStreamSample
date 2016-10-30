//
//  MemoryStreamSampleTests.swift
//  MemoryStreamSampleTests
//
//  Created by Hiroki Ishiura on 2016/10/29.
//  Copyright © 2016年 Hiroki Ishiura. All rights reserved.
//

import XCTest
@testable import MemoryStreamSample

class MemoryStreamSampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testUInt8() {
		let a: [UInt8] = [0x80]
		let b = UInt8(bytes: a)
		assert(b == 0x80)
		
		let c = b!.bytes()
		assert(c.count == 1 && c[0] == 0x80)
	}
	
	func testUInt32() {
		let a: [UInt8] = [0x01, 0x02, 0x03, 0x04]
		let b = UInt32(bytes: a)
		assert(b == 0x04030201)
		
		let c: [UInt8] = [0x01]
		let d = UInt32(bytes: c)
		assert(d == nil)

		let e = b!.bytes()
		assert(e.count == 4)
		assert(e.count == 4 &&
			e[0] == 0x01 && e[1] == 0x02 && e[2] == 0x03 && e[3] == 0x04
		)
	}
	
	func testInputStream() {
		let data = Data(bytes: [0x01, 0x02, 0x03, 0x04])
		let stream = MemoryInputStream(data: data)
		stream.integerByteOrder = .bigEndian
		stream.open()
		do {
			let a: UInt16 = try stream.readInteger()
			let b: UInt16 = try stream.readInteger()
			assert(a == 0x0102)
			assert(b == 0x0304)
		} catch {
			assertionFailure()
		}
		stream.close()
	}
	
	func testOutputStream() {
		let stream = MemoryOutputStream()
		stream.integerByteOrder = .bigEndian
		stream.open()
		do {
			let a = UInt16(0x0102)
			let b = UInt16(0x0304)
			try stream.write(integer: a)
			try stream.write(integer: b)
		} catch {
			assertionFailure()
		}
		stream.close()
		let data = stream.data()
		let b = data.bytes()
		assert(b.count == 4 &&
			b[0] == 0x01 && b[1] == 0x02 &&
			b[2] == 0x03 && b[3] == 0x04
		)
	}
}
