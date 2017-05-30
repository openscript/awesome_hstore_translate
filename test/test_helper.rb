$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'database_cleaner'
require 'awesome_hstore_translate'
require 'yaml'
require 'models/PageWithoutFallbacks'
require 'models/PageWithFallbacks'

DatabaseCleaner[:active_record].strategy = :transaction

class AwesomeHstoreTranslate::Test < MiniTest::Test
  class << self
    def prepare_database
      create_database
      create_table
    end

    private

    def database_configuration
      @db_config ||= begin
        YAML.load_file(File.join('test', 'database.yml'))['test']
      end
    end

    def establish_connection(config)
      ActiveRecord::Base.establish_connection(config)
      ActiveRecord::Base.connection
    end

    def create_database
      system_config = database_configuration.merge('database' => 'postgres', 'schema_search_path' => 'public')
      connection = establish_connection(system_config)
      connection.create_database(database_configuration['database']) rescue nil
      enable_extension
    end

    def enable_extension
      connection = establish_connection(database_configuration)
      unless connection.select_value("SELECT proname FROM pg_proc WHERE proname = 'akeys'")
        if connection.send(:postgresql_version) < 90100
          pg_sharedir = `pg_config --sharedir`.strip
          hstore_script_path = File.join(pg_sharedir, 'contrib', 'hstore.sql')
          connection.execute(File.read(hstore_script_path))
        else
          connection.execute('CREATE EXTENSION IF NOT EXISTS hstore')
        end
      end
    end

    def create_table
      connection = establish_connection(database_configuration)
      connection.create_table(:page_with_fallbacks, :force => true) do |t|
        t.column :title, 'hstore'
        t.column :author, :string
      end
      connection.create_table(:page_without_fallbacks, :force => true) do |t|
        t.column :title, 'hstore'
        t.column :author, :string
      end
    end
  end

  prepare_database

  def setup
    I18n.available_locales = %w(en en-US de)
    I18n.config.enforce_available_locales = true
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
