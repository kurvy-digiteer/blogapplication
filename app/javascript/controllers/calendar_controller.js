import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["allTime", "yearNav", "monthNav", "postsTable"]
  static values = {
    active: Boolean
  }

  connect() {
    this.updateActiveState()
  }

  // Handle All Time button click
  toggleAllTime(event) {
    event.preventDefault()
    const url = new URL(event.currentTarget.href)
    const params = new URLSearchParams(url.search)
    
    // Toggle all_time parameter
    if (params.get('all_time') === 'true') {
      params.delete('all_time')
    } else {
      params.set('all_time', 'true')
      // Remove any calendar parameters when enabling all_time
      params.delete('year')
      params.delete('month')
      params.delete('page')
      params.delete('month_page')
    }
    
    // Preserve sort parameters
    const sort = params.get('sort')
    const direction = params.get('direction')
    
    // Build new URL
    url.search = params.toString()
    
    // Use Turbo to visit the new URL
    Turbo.visit(url.toString())
  }

  // Update active state of buttons based on current URL
  updateActiveState() {
    const params = new URLSearchParams(window.location.search)
    const hasAllTime = params.get('all_time') === 'true'
    const hasYear = params.has('year')
    const hasMonth = params.has('month')

    // Update All Time button state
    if (this.hasAllTimeTarget) {
      this.allTimeTarget.classList.toggle('active', hasAllTime)
    }

    // Update calendar navigation visibility
    if (this.hasYearNavTarget) {
      this.yearNavTarget.style.display = hasAllTime ? 'none' : 'block'
    }
    if (this.hasMonthNavTarget) {
      this.monthNavTarget.style.display = (hasAllTime || !hasYear) ? 'none' : 'block'
    }
  }
} 