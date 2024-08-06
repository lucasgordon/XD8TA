import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "messages", "input" ]

  connect() {
    this.scrollToBottom()
    this.inputTarget.focus()
    this.element.addEventListener("turbo:submit-end", this.handleSubmit.bind(this))
  }

  handleSubmit(event) {
    if (event.detail && event.detail.success) {
      this.inputTarget.value = ""
      this.inputTarget.focus()
      this.scrollToBottom()
    }
  }

  scrollToBottom() {
    const chatHistory = this.messagesTarget;
    chatHistory.scrollTop = chatHistory.scrollHeight;
  }
}