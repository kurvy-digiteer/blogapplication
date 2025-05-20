import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "count"]

  toggle(event) {
    event.preventDefault()
    const button = this.buttonTarget
    const postId = button.dataset.postId
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
    .then(response => response.json())
    .then(data => {
      if (data.error) {
        console.error(data.error)
        return
      }

      this.countTarget.textContent = data.likes_count
      
      if (data.liked) {
        button.classList.add("liked")
        button.querySelector("i").classList.remove("far")
        button.querySelector("i").classList.add("fas")
      } else {
        button.classList.remove("liked")
        button.querySelector("i").classList.remove("fas")
        button.querySelector("i").classList.add("far")
      }
    })
    .catch(error => {
      console.error("Error:", error)
    })
  }
} 