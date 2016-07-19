require 'test_helper'

class AwesomeHstoreTranslateTest < AwesomeHstoreTranslate::Test
  def test_that_it_has_a_version_number
    refute_nil ::AwesomeHstoreTranslate::VERSION
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

  # def test_assigns_in_specified_locale
  #   I18n.with_locale(:en) do
  #     p = Page.new(:title_raw => {'en' => 'English title'})
  #     p.title_de = 'Deutscher Titel'
  #     assert_equal('Deutscher Titel', p.title_raw['de'])
  #   end
  # end

  # def test_persists_changes_in_specified_locale
  #   I18n.with_locale(:en) do
  #     p = Page.create!(:title_raw => {'en' => 'Original text'})
  #     p.title_en = 'Updated text'
  #     p.save!
  #     assert_equal('Updated text', Page.last.title_en)
  #   end
  # end

  # def test_retrieves_in_specified_locale
  #   I18n.with_locale(:en) do
  #     p = Page.new(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
  #     assert_equal('Deutscher Titel', p.title_de)
  #   end
  # end

  # def test_retrieves_in_specified_locale_with_fallbacks
  #   I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
  #   I18n.default_locale = :'en-US'
  #
  #   p = Page.new(:title_raw => {'en' => 'English title'})
  #   I18n.with_locale(:de) do
  #     assert_equal('English title', p.title_de)
  #   end
  # end

  # def test_fallback_from_empty_string
  #   I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
  #   I18n.default_locale = :'en-US'
  #
  #   p = Page.new(:title_raw => {'en' => 'English title', 'de' => ''})
  #   I18n.with_locale(:de) do
  #     assert_equal('English title', p.title_de)
  #   end
  # end

  # def test_retrieves_in_specified_locale_with_fallback_disabled
  #   I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
  #   I18n.default_locale = :'en-US'
  #
  #   p = Page.new(:title_raw => {'en' => 'English title'})
  #   p.disable_fallback
  #   I18n.with_locale(:de) do
  #     assert_equal(nil, p.title_de)
  #   end
  # end

  # def test_retrieves_in_specified_locale_with_fallback_disabled_using_a_block
  #   I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
  #   I18n.default_locale = :'en-US'
  #
  #   p = Page.new(:title_raw => {'en' => 'English title'})
  #   p.enable_fallback
  #
  #   assert_equal('English title', p.title_de)
  #   p.disable_fallback { assert_nil p.title_de }
  # end

  # def test_retrieves_in_specified_locale_with_fallback_reenabled
  #   I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
  #   I18n.default_locale = :'en-US'
  #
  #   p = Page.new(:title_raw => {'en' => 'English title'})
  #   p.disable_fallback
  #   p.enable_fallback
  #   I18n.with_locale(:de) do
  #     assert_equal('English title', p.title_de)
  #   end
  # end

  # def test_retrieves_in_specified_locale_with_fallback_reenabled_using_a_block
  #   I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
  #   I18n.default_locale = :'en-US'
  #
  #   p = Page.new(:title_raw => {'en' => 'English title'})
  #   p.disable_fallback
  #
  #   assert_nil(p.title_de)
  #   p.enable_fallback { assert_equal('English title', p.title_de) }
  # end

  def test_method_missing_delegates
    assert_raises(NoMethodError) { PageWithoutFallbacks.new.nonexistant_method }
  end

  def test_method_missing_delegates_non_translated_attributes
    assert_raises(NoMethodError) { PageWithoutFallbacks.new.other_de }
  end

  def test_persists_translations_assigned_as_hash
    p = PageWithoutFallbacks.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
    p.reload
    assert_equal({'en' => 'English title', 'de' => 'Deutscher Titel'}, p.title_raw)
  end

  # def test_persists_translations_assigned_to_localized_accessors
  #   p = Page.create!(:title_en => 'English title', :title_de => 'Deutscher Titel')
  #   p.reload
  #   assert_equal({'en' => 'English title', 'de' => 'Deutscher Titel'}, p.title_raw)
  # end

  # def test_with_translation_relation
  #   p = Page.create!(:title_raw => {'en' => 'English title', 'de' => 'Deutscher Titel'})
  #   I18n.with_locale(:en) do
  #     assert_equal p.title_en, Page.with_title_translation(English title).first.try(:title)
  #   end
  # end

  def test_class_method_translates?
    assert_equal true, PageWithoutFallbacks.translates?
  end
end
