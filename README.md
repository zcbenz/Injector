# Injector

A Safari App Extension that injects scripts and styles to webpages.

## Usage

1. Download and install `Injector.app` from Releases.
2. Create `~/.injector` folder, put `config.json` and scripts and styles in it.

## `config.json`

Format:

```json
{
  "websites": {
    "xxx.com": {
      "styles": [ "xxx.css" ],
      "scripts": [ "xxx.js" ]
    },
    "*.yyy.com": {
      "styles": [
        "yyy/block.css",
        "yyy/style.css"
      ]
    }
  }
}
```

## License

The code is published under public domain.
