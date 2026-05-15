import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    silentLetters: Boolean,
    confusedLetters: Boolean
  }

  connect() {
    if (this.confusedLettersValue) this.applyConfusedLetters()
    if (this.silentLettersValue) this.applySilentLetters()
  }

  applyConfusedLetters() {
    this.collectTextNodes().forEach(node => {
      const text = node.textContent
      if (!/[bdpqBDPQ]/.test(text)) return

      const parts = text.split(/([bdpqBDPQ])/)
      const fragment = document.createDocumentFragment()
      parts.forEach(part => {
        if (/^[bdpqBDPQ]$/.test(part)) {
          const span = document.createElement("span")
          span.className = "confused-letter"
          span.textContent = part
          fragment.appendChild(span)
        } else if (part) {
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

      // Vérifie si ce nœud est en fin de mot (suivi d'un espace ou ponctuation)
      const nextNode = nodes[idx + 1]
      const nextText = nextNode ? nextNode.textContent : " "
      const atWordEnd = /^[\s,;:.!?»)\-—\n"«»]/.test(nextText) || idx === nodes.length - 1

      if (!atWordEnd) return

      let prefix = text
      let silent = ""

      // Terminaison -ent (3ème personne du pluriel) — priorité haute
      if (text.length > 3 && text.endsWith("ent")) {
        prefix = text.slice(0, -3)
        silent = "ent"
      }
      // E final après une lettre (le cas le plus fréquent en français)
      else if (
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

  collectTextNodes() {
    const nodes = []
    const walker = document.createTreeWalker(this.element, NodeFilter.SHOW_TEXT, null)
    while (walker.nextNode()) nodes.push(walker.currentNode)
    return nodes
  }
}
