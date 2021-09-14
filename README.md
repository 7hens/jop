# jop

Use git to synchronize joplin notes

## install

Uses Bash (or Git bash on Windows):

```shell
curl -L https://gitee.com/7hens/jop/raw/main/jop -o jop && chmod +x jop
```

Or You just clone the repository, and add the dir to your PATH environment:

```shell
git clone https://gitee.com/7hens/jop.git
```

## command

| command            | description                          |
| ------------------ | ------------------------------------ |
| `jop`              | Sync                                 |
| `jop f`            | Fetch joplin notes from remote url   |
| `jop s`            | Sync, fetch and update joplin notes  |
| `jop s -i 5m`      | Sync interval (every 5m)             |
| `jop r`            | Reset the dir of joplin notes        |
| `jop u`            | Upgrade jop                          |
| `jop h`            | Help, list all available subcommands |
| `jop res-del <id>` | delete a spec resource               |
| `jop <cmd>`        | execute command on notes dir         |
