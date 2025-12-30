/**
 * Lock Protection Content Script
 * Prevents tab closure by showing browser's native "Leave page?" dialog
 * Injected into locked tabs dynamically
 */

(function() {
  'use strict';

  console.log('Tab Tree: Lock protection enabled');

  // Prevent tab closure with browser's native confirmation dialog
  window.addEventListener('beforeunload', handleBeforeUnload);

  function handleBeforeUnload(e) {
    // Standard way to trigger the browser's "Leave page?" dialog
    e.preventDefault();
    e.returnValue = ''; // Chrome requires this
    return ''; // Some browsers use return value
  }

  // Listen for unlock message from background script
  chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    if (message.type === 'unlock_protection') {
      console.log('Tab Tree: Lock protection disabled');
      window.removeEventListener('beforeunload', handleBeforeUnload);
      sendResponse({ success: true });
    }
  });

  // Notify background that protection is active
  chrome.runtime.sendMessage({
    type: 'protection_active',
    tabId: chrome.devtools?.inspectedWindow?.tabId,
  });
})();
