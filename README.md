# jop

Use git to synchronize joplin notes

## install

```shell
curl -L https://git.io/Jtggu -o jop
chmod +x jop
```

## command

| command       | description                        |
| ------------- | ---------------------------------- |
| `jop f`       | Fetch joplin notes from remote url |
| `jop s`       | Sync, fetch and update joplin note |
| `jop s -i 5m` | Sync interval (every 5m)           |
| `jop r`       | Reset dir of joplin notes          |
| `jop u`       | Upgrade jop                        |
| `jop h`       | Help, list available subcommands   |
| `jop <cmd>`   | execute command on notes dir       |
