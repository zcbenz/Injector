const EMPTY_CONFIG = {
  scripts: [],
  styles: [],
}

// Globals should only be accessed by the message handler bellow.
let globalCurrentPageConfig = EMPTY_CONFIG
let globalLoaded = false

safari.self.addEventListener('message', function(event) {
  if (event.name === 'extension-loaded') {
    // Extension can be loaded for multiple times.
    if (globalLoaded)
      return
    globalLoaded = true
    // Read passed configuration.
    try {
      readConfigs(globalCurrentPageConfig, event.message)
    } catch (error) {
      globalCurrentPageConfig = EMPTY_CONFIG
      console.error('Failed to parse configuration', error)
    }
    // Apply the config.
    applyConfig(globalCurrentPageConfig)
  }
})

function readConfigs(out, data) {
  // Merge all configs together.
  for (const file in data.files) {
    if (!file.endsWith('.json') || !data.files[file].content)
      continue
    readConfig(out, JSON.parse(data.files[file].content))
  }
  // Read file contents.
  for (name in out) {
    // Convert Set of filenames to Array of contents.
    const contents = []
    for (filename of out[name])
      contents.push(readFile(data, filename))
    out[name] = contents
  }
}

function readConfig(out, config) {
  for (const pattern in config.websites) {
    if (!domainMatch(pattern, window.location.hostname))
      continue
    const siteConfig = config.websites[pattern]
    for (const name in siteConfig) {
      if (!Array.isArray(siteConfig[name]) || siteConfig[name].length === 0)
        continue
      if (!(out[name] instanceof Set))
        out[name] = new Set
      out[name].add(...siteConfig[name])
    }
  }
}

function readFile(config, filename) {
  let node = config
  try {
    for (const component of filename.split('/'))
      node = node.files[component]
  } catch (error) {
    throw new Error(`${filename} is not a valid path`)
  }
  if (typeof node.content !== 'string')
    throw new Error(`${filename} is not a file`)
  return node.content
}

function applyConfig(config) {
  for (const script of config.scripts) {
    const element = document.createElement('script')
    element.innerHTML = '(function(){\n' + script + '\n})()'
    document.head.appendChild(element)
  }
  for (const style of config.styles) {
    const element = document.createElement('style')
    element.type = 'text/css'
    element.appendChild(document.createTextNode(style))
    document.head.appendChild(element)
  }
}

function domainMatch(pattern, domain) {
  if (pattern === '*')
    return true
  if (pattern.indexOf('*.') === 0)
    pattern = pattern.substr(2)
  if (pattern === domain)
    return true
  if (domain.endsWith(pattern))
    return true
  return false
}
