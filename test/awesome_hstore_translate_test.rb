require 'test_helper'

class AwesomeHstoreTranslateTest < AwesomeHstoreTranslate::Test
  def test_that_it_has_a_version_number
    refute_nil AwesomeHstoreTranslate::VERSION
  end

  def test_translated_attributes
    attr_names = PageWithFallbacks.translated_attribute_names
    assert_equal([:title], attr_names)
  end

  def test_translated_accessors
    attr_names = PageWithFallbacks.translated_accessor_names
    assert_equal([:title_en, :title_de], attr_names)
  end
  
  def test_assigns_in_current_locale
    I18n.with_locale(:en) do
      p = PageWithoutFallbacks.new(:title => 'English title')
      assert_equal('English title', p.title_raw['en'])
    end
  end

  def test_retrieves_in_current_locale
    p = PageWithoutFallbacks.new(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
    I18n.with_locale(:de) do
      assert_equal('Deutscher Titel', p.title)
    end
  end

  def test_retrieves_in_current_locale_with_fallbacks
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.default_locale = :'en-US'

    p = PageWithFallbacks.new(:title_raw => {'en' => 'English title'})
    I18n.with_locale(:de) do
      assert_equal('English title', p.title)
    end
  end

  def test_retrieves_in_current_locale_without_fallbacks
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.default_locale = :'en'

    p = PageWithoutFallbacks.new(:title_raw => {'en' => 'English title'})
    I18n.with_locale(:de) do
      assert_nil(p.title)
    end
  end


  def test_retrieves_with_regional_enabled_fallbacks
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.fallbacks.map(:en => :de)

    p = PageWithoutFallbacks.new(:title_raw => {'de' => 'Deutscher Titel'})
    I18n.with_locale(:en) do
      PageWithoutFallbacks.with_fallbacks do
        assert_equal('Deutscher Titel', p.title)
      end
    end
  end


  def test_retrieves_with_regional_disabled_fallbacks
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.fallbacks.map(:en => :de)

    p = PageWithFallbacks.new(:title_raw => {'de' => 'Deutscher Titel'})
    I18n.with_locale(:en) do
      PageWithFallbacks.without_fallbacks do
        assert_nil(p.title)
      end
    end
  end

  def test_assigns_in_specified_locale
    I18n.with_locale(:en) do
      p = PageWithFallbacks.new(:title_raw => {'en' => 'English title'})
      p.title_de = 'Deutscher Titel'
      assert_equal('Deutscher Titel', p.title_raw['de'])
    end
  end

  def test_persists_changes_in_specified_locale
    I18n.with_locale(:en) do
      p = PageWithFallbacks.create!(:title_raw => {'en' => 'Original text'})
      p.title_en = 'Updated text'
      p.save!
      assert_equal('Updated text', PageWithFallbacks.last.title_en)
    end
  end

  def test_retrieves_in_specified_locale
    I18n.with_locale(:en) do
      p = PageWithFallbacks.new(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
      assert_equal('Deutscher Titel', p.title_de)
    end
  end

  def test_retrieves_in_specified_locale_with_fallbacks
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.default_locale = :'en-US'

    p = PageWithFallbacks.new(:title_raw => {'en' => 'English title'})
    I18n.with_locale(:de) do
      assert_equal('English title', p.title_de)
    end
  end

  def test_fallback_from_empty_string
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.default_locale = :'en-US'

    p = PageWithFallbacks.new(:title_raw => {'en' => 'English title', 'de' => ''})
    I18n.with_locale(:de) do
      assert_equal('English title', p.title_de)
    end
  end

  def test_method_missing_delegates
    assert_raises(NoMethodError) { PageWithoutFallbacks.new.nonexistant_method }
  end

  def test_method_missing_delegates_non_translated_attributes
    assert_raises(NoMethodError) { PageWithoutFallbacks.new.other_de }
  end

  def test_persists_translations_assigned_as_hash
    p = PageWithoutFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
    assert_equal({'en' => 'English title', 'de' => 'Deutscher Titel'}, p.title_raw)
  end

  def test_persists_translations_assigned_to_localized_accessors
    p = PageWithFallbacks.create!(:title_en => 'English title', :title_de => 'Deutscher Titel')
    assert_equal({'en' => 'English title', 'de' => 'Deutscher Titel'}, p.title_raw)
  end

  def test_class_method_translates?
    assert_equal true, PageWithoutFallbacks.translates?
  end

  def test_where_query_with_translated_value
    PageWithFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
    exp = PageWithFallbacks.create!(:title_raw => {'en' => 'Another English title', 'de' => 'Noch ein Deutscher Titel'})
    res = PageWithFallbacks.where(title: 'Another English title').first
    assert_equal(exp.id, res.id)
  end

  def test_where_query_with_translated_value_and_other
    PageWithFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'},
                              author: 'Awesome')
    exp = PageWithFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'},
                              author: 'Spectacular')
    res = PageWithFallbacks.where(title: 'English title', author: 'Spectacular').first
    assert_equal(exp.id, res.id)
  end

  def test_fix_for_error_from_awesome_nested_table
    PageWithFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'},
                              author: 'Awesome')
    exp = PageWithFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'},
                              author: nil)
    res = PageWithFallbacks.where(PageWithFallbacks.arel_table[:author].eq(nil)).first
    assert_equal(exp.id, res.id)
  end

  def test_find_by_query_with_translated_value
    PageWithFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
    exp = PageWithFallbacks.create!(:title_raw => {'en' => 'Another English title', 'de' => 'Noch ein Deutscher Titel'})
    res = PageWithFallbacks.find_by(title: 'Another English title')
    assert_equal(exp.id, res.id)
  end

  def test_first_or_create_on_where
    exp = 'Titre français'
    res = PageWithFallbacks.where(title: exp).first_or_create!
    refute_empty(res.id.to_s)
    # this shouldn't be nil
    assert_equal(nil, res.title)

    exp = 'Titre français'
    res = PageWithFallbacks.where(title: exp).first_or_create!(title: exp)
    refute_empty(res.id.to_s)
    assert_equal(exp, res.title)
  end

  def test_find_or_create_by
    exp = 'Titre français'
    res = PageWithFallbacks.find_or_create_by(title: exp)
    refute_empty(res.id.to_s)
    assert_equal(exp, res.title)
  end

  def test_with_empty_translated_value
    new = PageWithFallbacks.new
    assert_nil(new.title)
  end

  def test_order_by
    PageWithFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'}, author: 'First')
    PageWithFallbacks.create!(:title_raw => {'en' => 'Another English title', 'de' => 'Noch ein Deutscher Titel'}, author: 'Second')
    PageWithFallbacks.create!(:title_raw => {'en' => 'Yet another English title', 'de' => 'Letzer Deutscher Titel'}, author: 'Third')

    res = PageWithFallbacks.all.order(title: :desc)
    assert_equal('Yet another English title', res.first.title)

    res = PageWithFallbacks.all.order(title: :asc)
    assert_equal('Another English title', res.first.title)

    res = PageWithFallbacks.all.order(:title)
    assert_equal('Another English title', res.first.title)

    I18n.with_locale(:de) do
      res = PageWithFallbacks.all.order(title: :desc)
      assert_equal('Noch ein Deutscher Titel', res.first.title)
    end

    I18n.with_locale(:de) do
      res = PageWithFallbacks.all.order(title: :asc)
      assert_equal('Deutscher Titel', res.first.title)
    end

    res = PageWithFallbacks.all.order(author: :desc)
    assert_equal('Third', res.first.author)

    res = PageWithFallbacks.all.order(author: :asc)
    assert_equal('First', res.first.author)
  end
end
