require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(12) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    letters = params[:letters]

    word_check(@word, letters)
  end

  private

  def included?(word, list)
    word.chars.all? { |letter| word.downcase.count(letter.downcase) <= list.downcase.count(letter.downcase) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def word_check(word, letters)
    if english_word?(word)
      if included?(word, letters)
        @message = "Nice One, #{word} is a valid English word"
      else
        @message = "Although #{word} is valid, please use letters on the grid"
      end
    else
      @message = "Sorry, #{word} is not an English word."
    end
  end
end
