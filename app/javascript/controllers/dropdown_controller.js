import { Controller } from "@hotwired/stimulus";
import Dropdown from "stimulus-dropdown";

export default class extends Dropdown {
  static targets = ["menu", "avatarMenu", "chevron"];

  connect() {
    super.connect();
  }

  toggle(event) {
    super.toggle();
  }

  hide(event) {
    super.hide(event);
  }

  toggleAvatarDropdown() {
    const isMenuVisible = this.avatarMenuTarget.style.display !== "none";
    this.avatarMenuTarget.style.display = isMenuVisible ? "none" : "block";
    this.chevronTarget.classList.toggle("rotate-0", !isMenuVisible);
    this.chevronTarget.classList.toggle("rotate-180", isMenuVisible);
  }
}
