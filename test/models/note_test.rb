require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  def setup
    @note = Note.new(content: 'hello world')
  end

  test 'content should be present' do
    @note.content = ''
    assert_not @note.valid?
  end
end
