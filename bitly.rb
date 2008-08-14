require 'rubygems'
require 'httparty'

class Bitly
  URL = 'http://bit.ly'
  include HTTParty
  base_uri URL
  
  def initialize(url)
    case url
    when %r{#{URL}/[^/]+}
      @short_url = url
    when %r{^(?![a-z\-\+\.]+://)} # not a full url, so a bit.ly identifier
      @short_url = [URL, url].join('/')
    else
      @url = url
    end
  end
  
  def url
    @url || self.class.get('/resolve', :query => {:url => @short_url})
  end
  
  def short_url
    @short_url || self.class.get('/api', :query => {:url => @url})
  end
      
end

if $0 == __FILE__
  require "test/unit"

  class TestBitly < Test::Unit::TestCase
    def test_bitly_short
      @bit = Bitly.new("2lkCCn")
      assert_equal "http://www.scripting.com/stories/2008/07/08/bitlyLaunchesToday.html", @bit.url
      assert_equal "http://bit.ly/2lkCCn", @bit.short_url
    end
    def test_bitly_long
      @bit = Bitly.new("http://inventors.about.com/library/weekly/aa081797.htm")
      assert_equal "http://inventors.about.com/library/weekly/aa081797.htm", @bit.url
      assert_equal "http://bit.ly/2beQam", @bit.short_url
    end
    def test_bitly_bitly_url
      @bit = Bitly.new("http://bit.ly/2lkCCn")
      assert_equal "http://www.scripting.com/stories/2008/07/08/bitlyLaunchesToday.html", @bit.url
      assert_equal "http://bit.ly/2lkCCn", @bit.short_url
    end
  end
end