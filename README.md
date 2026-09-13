# Lavalink Server

This project contains a Lavalink 4 server with YouTube, LavaSrc, LavaSearch,
and SlugYZeon plugins configured in `application.yml`.

## Requirements

- Java 17 or newer
- A Lavalink client or Discord bot that connects to this server
- Network access to the configured port

The included JAR is Lavalink Server 4.2.1 and is built for Java 17.

## Start Lavalink

Keep `Lavalink.jar` and `application.yml` in the same directory, then run:

```bash
java -jar Lavalink.jar
```

Lavalink reads `application.yml` automatically from the current directory.
The configured server listens on port `80`.

Before connecting a client, set the same password in the client that is
configured under `lavalink.server.password`.

## First-time setup

The most important values are near the relevant sections in
`application.yml`:

```yaml
server:
  port: 80

lavalink:
  server:
    password: change-this

plugins:
  youtube:
    oauth:
      refreshToken:
      skipInitialization: false
```

Change the password before exposing the server publicly. Do not commit
personal OAuth tokens or production credentials to the repository.

## YouTube OAuth setup

The configured YouTube plugin can use OAuth to make requests appear more like
normal account traffic. This is not guaranteed to prevent YouTube rate limits
or account action. Use a separate burner account, not a primary Google
account, and avoid high-traffic usage.

The current configuration starts with OAuth initialization enabled:

```yaml
plugins:
  youtube:
    enabled: true
    oauth:
      enabled: true
      refreshToken:
      skipInitialization: false
```

Use this process the first time:

1. Leave `refreshToken` empty.
2. Set `skipInitialization: false`.
3. Start Lavalink with `java -jar Lavalink.jar`.
4. Watch the console for the YouTube OAuth instructions.
5. Open the official URL shown by the console and complete the verification
   using the burner account.
6. After the OAuth flow completes, copy the refresh token printed in the
   Lavalink console.
7. Stop Lavalink.
8. Paste that refresh token into `plugins.youtube.oauth.refreshToken`.
9. Set `skipInitialization: true`.
10. Start Lavalink again.

Example after setup:

```yaml
oauth:
  enabled: true
  refreshToken: paste-your-refresh-token-here
  skipInitialization: true
```

The value printed by the console is a refresh token. Do not confuse it with
an OAuth access token. Access tokens are short-lived and can be passed by a
client through track `userData`; the persistent token used by this
configuration is `refreshToken`.

If no token is available yet, keep `refreshToken` empty and use
`skipInitialization: false` while completing the OAuth flow. The YouTube
plugin documentation notes that the token is printed only after the flow
successfully completes and that the related logger may need to be set to
`INFO`. This configuration already sets that logger to `INFO`.

## Configured sources

The following source settings are enabled in the current configuration.

### Built-in Lavalink sources

| Source | Status | Notes |
| --- | --- | --- |
| Bandcamp | Enabled | Direct source |
| HTTP | Enabled | Direct HTTP audio sources |
| Local files | Disabled | `local: false` |
| NicoNico | Enabled | Direct source |
| SoundCloud | Enabled | Direct source |
| Twitch | Enabled | Direct source |
| Vimeo | Enabled | Direct source |
| YouTube built-in source | Disabled | The YouTube plugin is used instead |

### SlugYZeon sources

| Source | Status |
| --- | --- |
| Amazon Music | Enabled |
| Pandora | Enabled |
| Spotify | Enabled |
| Gaana | Disabled |

SlugYZeon also defines YouTube search providers for ISRC and query-based
lookups.

### LavaSrc sources

| Source | Status |
| --- | --- |
| YouTube | Enabled |
| Apple Music | Disabled |
| Deezer | Disabled |
| Flowery TTS | Disabled |
| Spotify | Disabled |
| Yandex Music | Disabled |

Some services such as Spotify are commonly used for metadata or search and
may require a separate playable source for actual audio playback. Enable a
source only after checking the plugin documentation and its credential
requirements.

### LavaSearch indexes

LavaSearch is configured to index:

- Spotify
- YouTube

LavaSearch provides search functionality; it is not itself a replacement for
every source's playback implementation.

## Installed plugins and credits

These are the plugin declarations currently pinned in `application.yml`.

| Plugin | Current version | Repository | Credit |
| --- | --- | --- | --- |
| YouTube Source | `f45bbb7aebfcbc1c553769e04af6cd43afa8b7c3` snapshot | [lavalink-devs/youtube-source](https://github.com/lavalink-devs/youtube-source) | Lavalink Devs and repository contributors |
| SlugYZeon | `4.4.7` | [xylen-py/SlugYZeon](https://github.com/xylen-py/SlugYZeon) | xylen-py and contributors |
| LavaSrc | `4.8.3` | [topi314/LavaSrc](https://github.com/topi314/LavaSrc) | topi314 and contributors |
| LavaSearch | `1.0.0` | [topi314/LavaSearch](https://github.com/topi314/LavaSearch) | topi314 and contributors |

The YouTube plugin is downloaded from the Lavalink snapshot repository. The
other plugins use their configured release repositories:

- [Lavalink releases](https://maven.lavalink.dev/releases)
- [Lavalink snapshots](https://maven.lavalink.dev/snapshots)
- [JitPack](https://jitpack.io)

Please refer to each upstream repository for the current license, release
notes, compatibility requirements, and contribution credits.

## Remote cipher

The YouTube plugin is configured to use the following remote cipher service:

```yaml
remoteCipher:
  url: https://cipher.kikkia.dev/
  userAgent: lavalink-server
```

This endpoint is external to this repository. Check its availability and
terms before relying on it in production.

## Updating plugin versions

Plugin versions are intentionally pinned. Lavalink's plugin configuration
expects a concrete Maven version or snapshot identifier; it does not provide a
reliable `latest` setting for automatically selecting the newest compatible
plugin.

Using dynamic values such as `latest`, `latest.release`, or `+` is not
recommended because:

- a new release can introduce breaking changes;
- a plugin may no longer support the installed Lavalink version;
- snapshot builds can change without warning;
- a restart could download different code from the same configuration;
- failures become harder to reproduce.

To update a plugin safely:

1. Open the plugin's upstream repository and Releases page.
2. Check the release notes and required Lavalink version.
3. Replace only the version in `application.yml`.
4. Set `snapshot: true` only when using the snapshot repository.
5. Start Lavalink and check the startup logs for plugin loading errors.
6. Test searching and playback before using the update in production.

The YouTube plugin currently uses a pinned snapshot commit because YouTube
source compatibility can change quickly. Leave it pinned unless you have
tested a newer compatible version.

## Useful files

- `Lavalink.jar`: Lavalink server binary
- `application.yml`: server, source, plugin, OAuth, logging, and cipher settings
- `README.md`: setup and configuration guide