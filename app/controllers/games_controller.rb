require 'open-uri'

class GamesController < ApplicationController

  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters << alphabet.sample }
  end

  def score
    session[:score] = 0 if session[:score].nil?
    def word_check(grid, word)
      word.each do |letter|
        if word.count(letter) > grid.count(letter)
          session[:score] = 0
          return 'not in grid'
        end
      end
      dictionary(word.join)
    end

    def dictionary(word)
      url = "https://wagon-dictionary.herokuapp.com/#{word}"
      dictionary_hash = JSON.parse(open(url).read)
      if dictionary_hash['found']
        session[:score] += dictionary_hash['length'] ** 2
        return 'valid'
      else
        return 'not a word'
      end
    end

    @letters = params[:grid]
    @word = params[:word]
    split_word = @word.upcase.split("")
    @status = word_check(@letters.split, split_word)
    @score = session[:score]
  end
end
