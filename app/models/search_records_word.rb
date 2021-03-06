# == Schema Information
#
# Table name: search_records_words
#
#  id               :integer          not null, primary key
#  search_record_id :integer          not null
#  word_id          :integer          not null
#  position         :integer          not null
#  operation        :integer          default("add"), not null
#
# Indexes
#
#  index_search_records_words_on_search_record_id_and_position  (search_record_id,position) UNIQUE
#  index_search_records_words_on_search_record_id_and_word_id   (search_record_id,word_id) UNIQUE
#  index_search_records_words_on_word_id                        (word_id)
#
# Foreign Keys
#
#  fk_rails_...  (search_record_id => search_records.id) ON DELETE => cascade
#  fk_rails_...  (word_id => words.id)
#

class SearchRecordsWord < ApplicationRecord
  belongs_to :search_record
  belongs_to :word

  enum operation: {
    add: 0,
    subtract: 1
  }
end
