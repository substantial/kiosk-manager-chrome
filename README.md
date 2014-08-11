Kiosk Manager Chrome Extension
===============================

A Chrome extension for managing Chrome in the context of a public kiosk (like a photobooth). Features include:

+ Idle timer that closes tabs and redirects to homepage
+ scheduled deletion of session data
+ whitelist of navigable URLs

Development
-----------

### Requirements

+ [Node.js](http://nodejs.org) installed
+ [Grunt.js](http://gruntjs.com) installed
+ [CoffeeScript](http://coffeescript.org) installed

### Setup
1. `git clone git@github.com:mattpetrie/kiosk-manager-chrome.git`
2. `cd kiosk-manager-chrome`
3. `npm install`

### Building
Generate the complete packageable exstension into the **dist/** directory

1. `grunt build`

### Deployment

1. Open Google Chrome
3. Navigate to chrome://extensions
4. check the "Developer Mode" box in the upper right corner
5. click "Load unpacked extension..." and select the $PROJECT_ROOT/dist directory
