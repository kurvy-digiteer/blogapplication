import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "count"]

  toggle(event) {
    event.preventDefault()
    const button = this.buttonTarget
    const postId = button.dataset.postId
    const postPermalink = button.dataset.postPermalink
    const isLiked = button.classList.contains("liked")
    const url = isLiked ? `/posts/${postId}/likes/${button.dataset.likeId}` : `/posts/${postId}/likes`
    const method = isLiked ? "DELETE" : "POST"

    fetch(url, {
      method: method,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "application/json"
      }
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok')
      }
      return response.json()
    })
    .then(data => {
      if (data.error) {
        console.error(data.error)
        return
      }
      this.countTarget.textContent = data.likes_count
      // Redirect to the post page using permalink
      window.location.href = `/posts/${postPermalink}`
    })
    .catch(error => {
      console.error("Error:", error)
    })
  }
} 