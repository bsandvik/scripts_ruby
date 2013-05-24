#!/usr/bin/env ruby

def interactive
  # if stdout is a tty, the output of the script is not being redirected anywhere 
  $stdout.isatty
end

def interactive_puts(str)
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
    # this one isn't in use but the idea is that "helo" would return true for the word "hello" since all
    # letters are present. However, there doesn't seem to be much gain from running this check before is_a_solution
    !!(self =~ /^[#{letters}]+$/)
  end
  def is_a_solution(letters)
    # traverse each letter in the word (self)
    self.each_char do |c|
      # ... and try to write the word by pulling letters from your "hand"
      # this is done by deleting the letter from the string (replacing letter with "" using string substitution)
      remain = letters.sub(/#{c}/,"")
      if letters == remain then
        # if there are no required letters left, look for a wild (.)
        remain = letters.sub(/\./,"")
        if letters == remain then
          # if there are no wilds either to satisfy this letter, we know this is not a match
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
    interactive_puts "Using dictionary #{dict}"
    f = File.open(dict, "r:UTF-8") or die "Unable to open file..."
    words = f.readlines
    f.close
    matching = Array.new
    interactive_puts "Looking for words with #{minlength} or more letters"
    interactive_puts "That can be written using #{letters}"
    words.each do |word|
      newword = word.chomp
      # traverse dictionary and get rid of newline at the end of each word 
      if newword.is_long_enough(minlength) then
        # don't bother with solution check if word isn't long enough
        if newword.is_a_solution(letters) then
          matching.push(newword)
        end
      end
    end
    if matching.length > -1
      interactive_puts "There are #{matching.length} possibilities"
      matching.each do |word|
        puts word
      end
      return true
    else
      interactive_puts "No matches"
      return false
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
