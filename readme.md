Flashing using nix currently does not work, use:
```
nix build .#build
espflash flash --monitor --chip esp32c6 result
```
