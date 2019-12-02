// Don't show a dialog before entering Caret Browsing mode.
user_pref("accessibility.warn_on_browsewithcaret", false);

// Don't close the window when closing last tab.
user_pref("browser.tabs.closeWindowWithLastTab", false);

// Disable Pocket.
user_pref("extensions.pocket.enabled", false);

// Disable about:config warning.
user_pref("general.warnOnAboutConfig", false);

// Disable password manager.
user_pref("signon.rememberSignons", false);

// Disable the "new tab page" feature and show a blank tab instead.
user_pref("browser.newtabpage.enabled", false);
user_pref("browser.newtab.url", "about:blank");

// Set home page to about:blank.
user_pref("browser.startup.homepage", "about:blank");

// Disable recently used order for switching between tabs.
user_pref("services.sync.prefs.sync.browser.ctrlTab.recentlyUsedOrder", "false");

// Enable timestamps in console.
user_pref("devtools.webconsole.timestampMessages", "true");

// Keep console logs after navigating to another page.
user_pref("devtools.webconsole.persistlog", "true");

// Disable performance tab in developer tools.
user_pref("devtools.performance.enabled", "false");

// Vim keybindings in editor.
// user_pref("devtools.editor.keymap", "vim");

// Enable cryptomining and fingerprinting protection.
user_pref("privacy.trackingprotection.cryptomining.enabled", "true");
user_pref("privacy.trackingprotection.fingerprinting.enabled", "true");

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
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", "true");
