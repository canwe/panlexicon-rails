class GroupDecorator < ApplicationDecorator
  alias :group :object

  def search
    context[:search]
  end

  def key_word
    WordDecorator.new group.key_word, context
  end
end
