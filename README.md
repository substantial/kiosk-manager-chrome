Kiosk Manager Chrome Extension
===============================

A Chrome extension for managing Chrome in the context of a public kiosk (like a photobooth). Features include:

+ scheduled deletion of session data if the browser is idle
+ whitelist of navigable URLs
+ blocking of opening new tabs and fully closing the browser
+ Injection of custom JavaScript into every page

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
Generate the complete packageable extension into the **dist/** directory

1. `grunt build`

## To install in Chrome for Development and Testing
1. Open Google Chrome
3. Navigate to chrome://extensions
4. check the "Developer Mode" box in the upper right corner
5. click "Load unpacked extension..." and select the $PROJECT_ROOT/dist directory
6. Make sure the `Enabled` checkbox is checked for the extension to use it


Deployment
----------

The `grunt build` task creates a packaged version of the extension in the **package/** directory. Drag and drop this file into Chrome's chrome://extensions page to install.

Configuration
--------------

### Options page
The extension's options page is can be navigated to by clicking the options link on the chrome://extensions page. Options include:

+ Set a home page URL for your application
+ Set the idle time limit before the browser is reset
+ Set a whitelist of allowed domains the browser can navigate to, using comma separated values
+ Block users from opening new tabs in the browser
+ force the browser to reopen if the Chrome window is closed
+ Paste in JavaScript to be executed on each page

### Custom JavaScript
There are two ways to include additional JavaScript for the extension to execute on each page:

+ Small amounts of JS code can be pasted into the 'JavaScript to inject' field in the options page. Code placed here will be executed every time a new page loads.

+ You can add additional [content scripts](https://developer.chrome.com/extensions/content_scripts) to the **app/scripts/content-scripts/** directory before building the extension. Scripts add here must be added to the extension's [manifest file](https://developer.chrome.com/extensions/manifest) in **app/manifest.json** before building. Files added here will be automatically minified by the Grunt task at build time.

APIs
-----

### DOM API
The extension exposes a `kioskSessionDomApi` object to the DOM which you can access from your app's JS code to trigger session management events. The methods provided are:

+ `.resetSession` - fully resets the current browser session, including deleting all cookies and browsing data, closing extra tabs/windows, and redirecting to the home page URL.
+ `.clearPersonalInfo` - removes all cookies, browsing history, and other session data from the current browser session
+ `changeResetInterval` - changes the interval at which the idle detection will reset the brower session. This last only for the current browser session. To permanently change the interval it should be set in the extension's options page
+ `.tempResetInterval` - changes the idle detection reset interval for the current page only. The timer will revert to the default interval upon navigation away from the page. Useful if you want to have a longer or shorter idle timeout for a specific page like a home page.

### Content Script API
If you choose to add any additional content scripts, the extension also exposes a `kioskSessionCSAPI` for use in your content scripts. The methods provided are the same as the DOM API above.