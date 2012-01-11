#!/usr/bin/env ruby

require "logger"
require "optparse"
require "rexml/document"

require "sinatra"
require "json"

class String
  def blank?
    self.strip.empty?
  end
end

class NilClass
  def blank?
    true
  end
end

class FlattenXml
  def self.linearize(element, path)
    logger.debug "Processing node with path '#{path}' and text '#{element.text}'"

    unless element.has_elements?
      "#{path}=#{element.text}" unless element.text.blank?
    else
      element.elements.map do |child|
        # Print child nodes recursively
        linearize(child, "#{path}.#{child.name}")
      end.compact.join("\n")
    end

    # Print attributes here in the future
  end

  # Main
  def self.process(stream, prefix = '')
    # Parse the XML
    tree = REXML::Document.new(stream)

    # Get root element
    root = tree.root

    # Linearize
    root ? linearize(root, "#{prefix}#{"." unless prefix.blank?}#{root.name}") : ""
  end

  def self.logger
    @logger || Logger::new(STDERR)
  end
  def self.logger=(logger)
    @logger = logger
  end
end

logger = Logger::new(STDERR)
logger.level = Logger::INFO

FlattenXml.logger=logger

get '/' do
  '<form action="parse" method="post">
     <textarea rows="40" cols="100" name="xml"></textarea>
     <input type="submit" value="Flatten!" />
   </form>'
end

post '/parse' do
  "<h1>Your XML translated to properties file format:</h1><br />
  <pre>
#{FlattenXml.process(params[:xml])}
  </pre>
  <b>Nifty, huh<b>?
  "
end
