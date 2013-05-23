#!/usr/bin/env ruby

def interactive
  # if stdout is a tty, the output of the script is not being redirected anywhere 
  $stdout.isatty
end

def intputs(str)
  # only puts if ran interactively
  if interactive
    puts str
  end
end 
  
class String
  # extending string class with a few more methods
  def is_int?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
  def is_long_enough(minlength)
    self.length >= minlength
  end
  def has_required_letters(letters)
    !!(self =~ /^[#{letters}]+$/)
  end
  def is_a_solution(letters)
    self.each_char do |c|
      remain = letters.sub(/#{c}/,"")
      if letters == remain then
        # if there are no required letters left, look for a wild (.)
        remain = letters.sub(/\./,"")
        if letters == remain then
          return false
        end
      end
      letters = remain
    end
    true
  end # method is_a_solution
end # class String


class AllWords
  attr_accessor :dict, :minlength, :letters
  def initialize(dict = "/usr/share/dict/words")
    @dict = dict
    @minlength = minlength
    @letters = letters
  end
  def list_words 
    intputs "Using dictionary #{dict}"
    f = File.open(dict, "r:UTF-8") or die "Unable to open file..."
    words = f.readlines
    f.close
    matching = Array.new
    intputs "Looking for words with #{minlength} or more letters"
    intputs "That can be written using #{letters}"
    words.each do |word| 
      newword = word.chomp
      if newword.is_long_enough(minlength) then
         if newword.is_a_solution(letters) then
           matching.push(newword)
         end
      end
    end
    if matching.nil?
      puts "No solutions"
      return false
    elsif matching.length > -1
      intputs "There are #{matching.length} possibilities"
      matching.each do |word|
        puts word
      end
    end
  end # list_words method
end # AllWords class

arglength = 0
argletters = ""

ARGV.each do |arg|
  isint = arg.is_int?
  if isint then
    arglength = arg.to_i
  else
    argletters = arg
  end
end

words = AllWords.new(dict="english.wwf")
words.minlength=arglength
words.letters=argletters
words.list_words
