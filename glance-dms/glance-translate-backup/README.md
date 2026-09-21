# Glance Translate — DMS Plugin

One-click text translation for your DankMaterialShell bar. Select any text on screen, click the translate icon, and get an instant translation.

## Features

- **Auto-translate selection**: Opens with your highlighted text already translated
- **Manual input**: Type or paste any text to translate
- **Multi-engine**: Google (default), DeepL, Bing, Yandex, Apertium
- **Configurable target language**: Defaults to Chinese (zh-CN), supports any BCP-47 code
- **Copy result**: One-click copy translation to clipboard
- **Keyboard shortcut**: Bind via `dms ipc call widget toggle glance`
- **Theme-aware**: Follows your DMS color scheme

## Requirements

- [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
- [translate-shell](https://github.com/soimort/translate-shell) (`sudo apt install translate-shell`)
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (already a DMS dependency)

## Install

```bash
dms plugins install glance
```

Or manually:
```bash
git clone https://github.com/ChaoXu1997/glance.git
cp -r glance/plugin ~/.config/DankMaterialShell/plugins/glance
dms ipc call plugins reload glance
```

## Configuration

Open plugin settings in DMS:

| Setting | Default | Options |
|---------|---------|---------|
| Target Language | zh-CN | Any BCP-47 code (ja, en, de, fr, ko...) |
| Translation Engine | google | google, deepl, bing, yandex, apertium |

### Keyboard Shortcut (niri)

Add to your niri config:
```
binds {
    Mod+T { spawn "dms" "ipc" "call" "widget" "toggle" "glance"; }
}
```

## Screenshot

<!-- TODO: Add screenshot of the translate popout panel -->

## License

MIT
