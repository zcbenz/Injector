safari.extension.dispatchMessage('extension-loaded')

document.addEventListener('DOMContentLoaded', function(event) {
  safari.extension.dispatchMessage('dom-onload')
})
