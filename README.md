# README

This is a *userscript* as it that looks into the DOM of facebook pages to find specific patterns in order to delete ads that are located within the timeline.

## Running the project

You need to have node.js installed as well as npm. This project has been built using node `v6.2.0` but should likely work with any node `0.12.x+`.

- `npm install`
- `npm install -g coffee-script gulp` *Necessary to run a **gulpfile.coffee**.*
- `gulp look` or `gulp`

Only update the files in the `src` folder. The files in the `dist` folder are not to be modified manually, gulp takes care of that.

_The `dist` folder is only tracked by git to allow third-party support like automated update from_ https://openuserjs.org

## TODO list:

- Publish as a userscript.
- Make a Chrome extension. Publish it.
    * Need icons (19, 48, 128, disabled) (replace current ones, they're just for testing, I stole them from my brother!) =D
- Support multiple languages (`texts` in hard?)
- Use a DB of sort to share `texts` (acts as a blacklist)
- Settings to update the blacklist.

The current files may look like a Chrome Extension, but it's not one yet.

## Contributing

Feel free to make a PR! But please read the [guidelines](./CONTRIBUTING.md) first.

## License

Open source MIT. Feel free to use/modify/whatever.
