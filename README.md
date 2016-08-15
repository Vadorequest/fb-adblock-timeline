[![Code Climate](https://codeclimate.com/github/Vadorequest/fb-adblock-timeline/badges/gpa.svg)](https://codeclimate.com/github/Vadorequest/fb-adblock-timeline)
[![Issue Count](https://codeclimate.com/github/Vadorequest/fb-adblock-timeline/badges/issue_count.svg)](https://codeclimate.com/github/Vadorequest/fb-adblock-timeline)

# README

This is a *userscript* as it that looks into the DOM of facebook pages to find specific patterns in order to delete ads that are located within the timeline.

## Intro

There are two ways to use this tool.

1. As a `userscript`.
1. As a Chrome extension.

### 1. Userscript

A userscript is a script *(Captain Obvious is in the place!)*, it is managed by a script manager. (like Tampermonkey)
The script manager basically allow you to load, enable/disable, modify and delete scripts on your browser.

Pretty straight-forward:

1. Install [Tampermonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo) if you don't have it. (P.S: You can use another script manager of your own, but this one is a good one if you don't have any)
1. Load the [userscript](./dist/userscript/fb-adblock-timeline.user.js) and enable it.
1. Enjoy the magic *(refresh facebook page to apply)*

That's it. You can now browse Tampermonkey to install more scripts! 
*But beware, only install from a trusted source, userscripts can be harmful.*


### 2. Chrome extension

Install at https://chrome.google.com/webstore/detail/efodhgbopaihacnjakjllbfdhhpioafo

## Running the project

You need to have node.js installed as well as npm. This project has been built using node `v6.2.0` but should likely work with any node `0.12.x+`.

- `npm install`
- `npm install -g coffee-script gulp` _Necessary to run a **gulpfile.coffee**._
- `gulp look` or `gulp`

Only update the files in the `src` folder. The files in the `dist` folder are not to be modified manually, gulp takes care of that.

_The `dist` folder is only tracked by git to allow third-party support like automated update from_ https://openuserjs.org

## Possible improvements:

I'm mostly concerned about the languages limitations, here are some ideas to deal with it.
I won't look into it, except if it gets used by many people. But feel free to propose something if you have any idea.

- Support multiple languages 
    - [x] `texts` in hard? -> *That's what's done at the moment, need manual change or PR*
    - [ ] Use a DB of sort to share `texts` (acts as a blacklist)
    - [ ] Settings to update the blacklist.

## Contributing

Feel free to make a PR! But please read the [guidelines](./CONTRIBUTING.md) first.

## License

Open source MIT. Feel free to use/modify/whatever.
