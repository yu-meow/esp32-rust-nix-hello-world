# ESP-32 Hello World with Nix example
Compile target is for riscv32 based ESP-32, can be adjusted for xtensa based ESP-32.

## Preparation
You likely need to adjust `sha256 = "..."` first or when updating the lock file.
To do this, run one of the commands below. Nix will give u a hash mismatch error, showing the actual hash of the rust compiler. Copy this to the `flake.nix` file

## Build and flash
Flashing using nix currently does not seem to work.
Running espflash in Nix gives this error:
```
/sys/class/tty/ doesn't exist on this system
```
If you know a solution, please let me know.

Use this instead:
```
nix build .#build
espflash flash --monitor --chip esp32c6 result
```
(Needs espflash installed manually on the host system)

## Build only
```
nix build .#build
```

## Dev shell
```
nix develop
```
