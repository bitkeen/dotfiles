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
