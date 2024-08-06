import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "messages", "input" ]

  connect() {
    this.element.addEventListener("turbo:submit-end", this.handleSubmit.bind(this))
  }

  handleSubmit(event) {
    if (event.detail && event.detail.success) {
      this.inputTarget.value = ""
      this.inputTarget.focus()
      setTimeout(() => {
        this.animateLatestAgentResponse()
        this.scrollToBottom()
      }, 100)
    }
  }

  animateLatestAgentResponse() {
    const agentResponses = this.messagesTarget.querySelectorAll('.agent-message[data-animate="true"]')
    const latestAgentResponse = agentResponses[agentResponses.length - 1]
    
    if (latestAgentResponse) {
      const fullText = latestAgentResponse.textContent
      latestAgentResponse.textContent = ''
      this.typeWriter(latestAgentResponse, fullText, 0)
      latestAgentResponse.removeAttribute('data-animate')
    }
  }

  typeWriter(element, text, index) {
    if (index < text.length) {
      element.textContent += text.charAt(index)
      index++
      setTimeout(() => this.typeWriter(element, text, index), 20) 
    }
  }

  scrollToBottom() {
    const chatHistory = this.messagesTarget
    chatHistory.scrollTop = chatHistory.scrollHeight
  }
}