require 'pathname'

namespace :moby do
  desc "Import comma-separated values from Moby Thesaurus"
  task :import_thesaurus, [:file_path] => [:environment, 'log_level:info'] do |t, args|
    args.with_defaults file_path: 'mthesaur.txt'

    filepath = Pathname(args[:file_path])
    unless filepath.exist?
      abort "Cannot find file: #{filepath.realpath}"
    end

    importer = MobyImporter.new
    importer.thesaurus(filepath)
  end

  task :import_parts_of_speech, [:file_path] => :environment do |t, args|
    args.with_defaults file_path: 'mobypos.txt'

    filepath = Pathname(args[:file_path])
    unless filepath.exist?
      abort "Cannot find file: #{filepath.realpath}"
    end

    importer = MobyImporter.new
    importer.parts_of_speech(filepath)
  end

  desc "Download cached Thesaurus data"
  task thesaurus_db: [:environment, 'log_level:info'] do |t, args|
    require 'open-uri'

    open('data.sql.tar', 'wb') do |file|
      file << open('https://github.com/bensheldon/panlexicon-rails/releases/download/v1/data.sql.tar').read
    end

    if ENV['RAILS_ENV'] == 'staging'
      system "
        pg_restore --verbose --data-only --no-acl --no-owner \
          -d $DATABASE_URL \
          data.sql.tar
      "
    else
      system "
        pg_restore --verbose --data-only --no-acl --no-owner \
          -h localhost -U $(whoami) -d panlexicon_#{ENV.fetch('RAILS_ENV', 'development')} \
          data.sql.tar
      "
    end
  end
end
