import { Controller } from "@hotwired/stimulus"

const PAIR_CHARS = {
  bd:   ["b", "d"],
  pq:   ["p", "q"],
  nm:   ["n", "m"],
  un:   ["u", "n"],
  ouon: ["ou", "on"],
  euen: ["eu", "en"],
  "69": ["6", "9"]
}

export default class extends Controller {
  static values = {
    silentLetters: Boolean,
    confusedPairs: String,
    confusedCustom: String
  }

  connect() {
    const hasConfused = this.confusedPairsValue || this.confusedCustomValue
    if (hasConfused) this.applyConfusedLetters()
    if (this.silentLettersValue) this.applySilentLetters()
  }

  applyConfusedLetters() {
    const patterns = this.buildPatterns()
    if (patterns.length === 0) return

    const escaped = patterns.map(p => p.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"))
    const regex = new RegExp(`(${escaped.join("|")})`, "gi")

    this.collectTextNodes().forEach(node => {
      const text = node.textContent
      if (!text || !regex.test(text)) { regex.lastIndex = 0; return }
      regex.lastIndex = 0

      const parts = text.split(regex)
      const fragment = document.createDocumentFragment()
      parts.forEach((part, i) => {
        if (!part) return
        if (i % 2 === 1) {
          const span = document.createElement("span")
          span.className = "confused-letter"
          span.textContent = part
          fragment.appendChild(span)
        } else {
          fragment.appendChild(document.createTextNode(part))
        }
      })
      node.parentNode.replaceChild(fragment, node)
    })
  }

  applySilentLetters() {
    const nodes = this.collectTextNodes()

    nodes.forEach((node, idx) => {
      const text = node.textContent
      if (!text || text.trim() === "") return

      const nextNode = nodes[idx + 1]
      const nextText = nextNode ? nextNode.textContent : " "
      const atWordEnd = /^[\s,;:.!?»)\-—\n"«»]/.test(nextText) || idx === nodes.length - 1

      if (!atWordEnd) return

      let prefix = text
      let silent = ""

      if (text.length > 3 && text.endsWith("ent")) {
        prefix = text.slice(0, -3)
        silent = "ent"
      } else if (
        text.length > 1 &&
        text.endsWith("e") &&
        /[a-zA-ZéèêëàâùûîôœÉÈÊËÀÂÙÛÎÔŒ]/.test(text.slice(-2, -1))
      ) {
        prefix = text.slice(0, -1)
        silent = "e"
      }

      if (!silent) return

      const fragment = document.createDocumentFragment()
      if (prefix) fragment.appendChild(document.createTextNode(prefix))
      const span = document.createElement("span")
      span.className = "silent-letter"
      span.textContent = silent
      fragment.appendChild(span)
      node.parentNode.replaceChild(fragment, node)
    })
  }

  buildPatterns() {
    const selected = new Set()

    this.confusedPairsValue.split(",").filter(Boolean).forEach(pair => {
      (PAIR_CHARS[pair] || []).forEach(c => selected.add(c))
    })

    this.confusedCustomValue.trim().split(/\s+/).filter(Boolean).forEach(c => {
      selected.add(c.toLowerCase())
    })

    return [...selected].sort((a, b) => b.length - a.length)
  }

  collectTextNodes() {
    const nodes = []
    const walker = document.createTreeWalker(this.element, NodeFilter.SHOW_TEXT, null)
    while (walker.nextNode()) nodes.push(walker.currentNode)
    return nodes
  }
}
