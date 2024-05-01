import NestedForm from 'stimulus-rails-nested-form'

export default class extends NestedForm {
  connect() {
    super.connect();
  }

  remove(event) {
    event.preventDefault();
    let wrapper = this.nestedFormWrapperTarget;

    // Remove the entire wrapper containing the nested form fields
    wrapper.remove();
  }
}
