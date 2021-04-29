# jop

Use git to synchronize joplin notes

## install

```shell
curl -L https://gitee.com/7hens/jop/raw/main/jop -o jop && chmod +x jop
```

## command

| command       | description                          |
| ------------- | ------------------------------------ |
| `jop f`       | Fetch joplin notes from remote url   |
| `jop s`       | Sync, fetch and update joplin notes  |
| `jop s -i 5m` | Sync interval (every 5m)             |
| `jop r`       | Reset the dir of joplin notes        |
| `jop u`       | Upgrade jop                          |
| `jop h`       | Help, list all available subcommands |
| `jop <cmd>`   | execute command on notes dir         |
