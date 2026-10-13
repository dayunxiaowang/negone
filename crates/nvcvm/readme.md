# NegOne CVM API (`nvcvm`)

This crate exposes NegOne's Customizable VM API to user-mode virtual machine monitors and platform drivers. It is derived from NoirVisor's Rust CVM library.

The Cargo package name `nvcvm`, exported `ncv_*` C function names, and existing protocol layouts are retained for compatibility. Windows clients built from this fork connect to `\Device\NegOne`; rebuild clients that previously opened `\Device\NoirVisor`.

See [the fork compatibility notes](../../doc/fork.md) for the naming and protocol boundaries. The inherited Rust API is not backward-compatible with the original [NoirCvmApi C project](https://github.com/Zero-Tang/NoirCvmApi).

## License

This crate retains its MIT license and original copyright notices.
