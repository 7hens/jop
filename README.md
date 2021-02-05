# jop

Use git to synchronize joplin notes

## install

```shell
curl -L https://git.io/Jtggu -o jop
chmod +x ./jop
```

## command

| command            | description                        |
| ------------------ | ---------------------------------- |
| `./jop fetch`      | Fetch joplin notes from remote url |
| `./jop sync`       | Fetch and update joplin note       |
| `./jop sync -i 5m` | Sync interval (every 5m)           |
| `./jop reset`      | Reset dir of joplin notes          |
| `./jop upgrade`    | Upgrade jop                        |
| `./jop help`       | List available subcommands         |
