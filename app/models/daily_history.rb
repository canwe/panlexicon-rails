class DailyHistory
  include ActiveModel::Model

  HISTORY_SQL = File.read Rails.root.join('app/models/sql/search_history.sql.erb')

  attr_accessor :date, :words

  def self.all(user: User.null, after_date: nil)
    args = {
      user_id: user&.id,
      after_date: after_date,
      max_words_per_day: Search::MAX_RELATED_WORDS,
      max_weight: Search::MAX_WEIGHT,
    }
    query_sql = ERB.new(HISTORY_SQL).result(OpenStruct.new(args).instance_eval { binding })

    words = Word.find_by_sql [query_sql, args]
    words.group_by(&:date).map do |date, words|
      new(date: date, words: words)
    end
  end
end
