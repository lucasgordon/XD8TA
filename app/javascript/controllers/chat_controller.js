import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["messages", "input", "submit"]

  connect() {
    this.scrollToBottom()
    this.inputTarget.focus()
    this.element.addEventListener("turbo:submit-end", this.handleSubmit.bind(this))
  }

  handleSubmit(event) {
    if (event.detail && event.detail.success) {
      this.inputTarget.value = ""
      this.inputTarget.disabled = true
      this.submitTarget.disabled = true
      this.startCountdown()
      this.scrollToBottom()
    }
  }

  scrollToBottom() {
    const chatHistory = this.messagesTarget;
    chatHistory.scrollTop = chatHistory.scrollHeight;
  }

  startCountdown() {
    let counter = 10;
    const originalPlaceholder = this.inputTarget.placeholder; // Save the original placeholder
    const interval = setInterval(() => {
      this.inputTarget.placeholder = `You can send a new message in ${counter--} seconds`;
      if (counter < 0) {
        clearInterval(interval);
        this.inputTarget.disabled = false;
        this.submitTarget.disabled = false;
        this.inputTarget.placeholder = originalPlaceholder; // Restore the original placeholder
      }
    }, 1000);
  }
}