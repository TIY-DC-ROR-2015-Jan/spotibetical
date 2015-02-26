# Spotibetical

[![Build Status](https://travis-ci.org/TIY-DC-ROR-2015-Jan/spotibetical.svg?branch=playlist_push)](https://travis-ci.org/TIY-DC-ROR-2015-Jan/spotibetical)
[![Coverage Status](https://coveralls.io/repos/TIY-DC-ROR-2015-Jan/spotibetical/badge.svg)](https://coveralls.io/r/TIY-DC-ROR-2015-Jan/spotibetical)

Crowdsourced, democratic Spotify playlist generation for Friday huddles.

See the live version at [spotibetical.herokuapp.com](http://spotibetical.herokuapp.com) _(you will need to request a login from an org member)_.

## Running Locally

You may need the following local environment variables:

```
SPOTIFY_ID=...      # To push playlists to Spotify
SPOTIFY_SECRET=...  # Similarly
MANDRILL_APIKEY=... # To send emails e.g. on signup
```

Please run `get_spotify_token.rb` to generate your initial `SpotifyAccessToken`; it should auto-refresh as needed from there.