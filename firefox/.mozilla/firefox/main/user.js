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
