# MemoryStreamSample

This application is a sample which accessing memory stream.

## MemoryInputStream

### Functions

- `integerByteOrder` ... `.littleEndian` or `.bigEndian`
- `streamDataLength` ... The length of readable bytes from stream.
- `open()` and `close()`
- `readInteger() -> T` ... `T` is `UInt8`, `UInt16`, `UInt32` and `UInt64`.
- `readString(length: Int) -> String`
- `readData(length: Int) -> Data`
- `readBytes(length: Int) -> [UInt8]`

### Example

```
let data = Data(bytes: [0x01, 0x02, 0x03, 0x04])
let stream = MemoryInputStream(data: data)
stream.integerByteOrder = .bigEndian
stream.open()
do {
	let a: UInt16 = try stream.readInteger()
	let b: UInt16 = try stream.readInteger()
	print("a=\(a), b=\(b)")
} catch {
	print("\(error)")
}
stream.close()
```

## MemoryOutputStream

### Functions

- `integerByteOrder` ... `.littleEndian` or `.bigEndian`
- `open()` and `close()`
- `write(integer: T)` ... `T` is `UInt8`, `UInt16`, `UInt32` and `UInt64`.
- `write(string: String, length: Int)`
- `write(data: Data, length: Int)`
- `write(bytes: [UInt8], length: Int)`
- `data() -> Data` ... Get data are pooled in the stream.

### Example

```
let stream = MemoryOutputStream()
stream.integerByteOrder = .bigEndian
stream.open()
do {
	let a = UInt16(0x0102)
	let b = UInt16(0x0304)
	try stream.write(integer: a)
	try stream.write(integer: b)
} catch {
	print("\(error)")
}
stream.close()
let data = stream.data()
print("data=\(data)")
```

## Requirements

* macOS 10.12
* iOS 10.0
* Xcode 8.1
* Swift 3.0.1


## License

Please read [this file](LICENSE).
