// Disable three-pane inspector.
user_pref("devtools.inspector.three-pane-enabled", false);

// Don't show a dialog before entering Caret Browsing mode.
user_pref("accessibility.warn_on_browsewithcaret", false);

// Don't close the window when closing last tab.
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Disable Pocket.
user_pref("extensions.pocket.enabled", false);

// Disable about:config warning.
user_pref("browser.aboutConfig.showWarning", false);

// Disable password manager.
user_pref("signon.rememberSignons", false);

// Disable the "new tab page" feature and show a blank tab instead.
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.url", "about:blank");

// Set home page to about:blank.
user_pref("browser.startup.homepage", "about:blank");

// Disable recently used order for switching between tabs.
user_pref("services.sync.prefs.sync.browser.ctrlTab.recentlyUsedOrder", false);

// Enable timestamps in console.
user_pref("devtools.webconsole.timestampMessages", true);

// Keep console logs after navigating to another page.
user_pref("devtools.webconsole.persistlog", true);

// Disable performance tab in developer tools.
user_pref("devtools.performance.enabled", false);

// Set columns for network tab.
user_pref("devtools.netmonitor.visibleColumns", "[\"status\",\"method\",\"url\",\"transferred\",\"contentSize\",\"duration\"]");

// Enable cryptomining and fingerprinting protection.
user_pref("privacy.trackingprotection.cryptomining.enabled", true);
user_pref("privacy.trackingprotection.fingerprinting.enabled", true);

// The defaults go back and forth in history.
user_pref("browser.gesture.swipe.left", "cmd_scrollLeft");
user_pref("browser.gesture.swipe.right", "cmd_scrollRight");

// Compact UI density.
user_pref("browser.uidensity", 1);

// Set download dir.
user_pref("browser.download.dir", "/home/user/downloads/firefox");
user_pref("browser.download.lastDir", "/home/user/downloads/firefox");

// Don't display close buttons on tabs with lower width.
user_pref("browser.tabs.tabClipWidth", "9000");

// Load userChrome.css and userContent.css.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Restore previous session on startup.
user_pref("browser.startup.page", "3");

// Disable extension recommendations.
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Highlight all search results.
user_pref("findbar.highlightAll", true);

// Disable IDN.
user_pref("network.IDN_show_punycode", true);

// Show bookmark editor popup on saving.
user_pref("browser.bookmarks.editDialog.showForNewBookmarks", true);

// Set max cache capacity to 10GiB (the default is 1GiB).
user_pref("browser.cache.disk.capacity", "10485760");

// Use last download dir.
user_pref("browser.download.folderList", 2);

// Dark theme for devtools.
user_pref("devtools.theme", "dark");

// Never display bookmarks toolbar.
user_pref("browser.toolbars.bookmarks.visibility", "never");

// Disable search suggestions.
user_pref("browser.search.suggest.enabled", false);

// Scale up developer tools.
user_pref("devtools.toolbox.zoomValue", "1.3");

// Block audio and video autoplay.
user_pref("media.autoplay.default", 5);

// Firefox devtools will truncate larger responses. Default is 1048576.
user_pref("devtools.netmonitor.responseBodyLimit", 16777216);

// Disable prompts to enable DRM.
user_pref("browser.eme.ui.enabled", false);

// The default is 7.
user_pref("browser.bookmarks.editDialog.maxRecentFolders", 16);

// Disable Firefox View.
user_pref("browser.tabs.firefox-view", false);

// Prioritize bookmarks in address bar.
user_pref("places.frecency.bookmarkVisitBonus", 10000);
user_pref("places.frecency.unvisitedBookmarkBonus", 10000);

// -1.0 is the default, make it explicit.
user_pref("layout.css.devPixelsPerPx", "-1.0");
