# En Passant

En Passant is a chess app written in Flutter using Flame engine. It is a remake of [Checkmate](https://github.com/PScottZero/Checkmate), a SwiftUI project which I submitted as my final project for an application development course I took at Penn State (CMPSC 475) during the fall of 2020.

<a href='https://play.google.com/store/apps/details?id=com.pscottzero.en_passant&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' width='300'/></a>
<a href='https://apps.apple.com/app/en-passant-chess-app/id1560929429'><img alt='Download on the App Store' src='https://developer.apple.com/app-store/marketing/guidelines/images/badge-download-on-the-app-store.svg' width='300'/></a>

## Features
- 1 or 2 player gameplay (2 player is offline)
- Six AI difficulty levels
- Customizable app theme
- Customizable piece theme

## AI Description

The chess AI I developed for this app uses the minimax algorithm with alpha-beta pruning to calculate which moves to make. This source is what helped me code the actual AI as it has a pseudo-code example of the algorithm which I adapted for my app. There are six difficulty levels in the app, each level corresponding to the depth of the search used in the minimax algorithm. The highest difficulty is 6, which corresponds to 3 full chess moves. To learn more about how this algorithm works, use the following link: https://en.wikipedia.org/wiki/Alpha–beta_pruning.

## Screenshots

<img width="200" src="https://i.imgur.com/lLkWK2x.png"> <img width="200" src="https://i.imgur.com/ayH4qX3.png"> <img width="200" src="https://i.imgur.com/FrpAHvk.png"> <img width="200" src="https://i.imgur.com/4YXxF6V.png">
