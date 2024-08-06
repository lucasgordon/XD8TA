import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "messages", "input" ]

  connect() {
    this.element.addEventListener("turbo:submit-end", this.handleSubmit.bind(this))
    this.scrollToBottom()
  }

  handleSubmit(event) {
    if (event.detail && event.detail.success) {
      this.inputTarget.value = ""
      this.inputTarget.focus()
      setTimeout(() => {
        this.scrollToBottom()
      }, 100)
    }
  }

  scrollToBottom() {
    const chatHistory = this.messagesTarget
    chatHistory.scrollTop = chatHistory.scrollHeight
  }
}