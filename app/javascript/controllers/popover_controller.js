import Popover from 'stimulus-popover'

export default class extends Popover {
  connect() {
    super.connect()
    console.log('Do what you want here.')
  }
}