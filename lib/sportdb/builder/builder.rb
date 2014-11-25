# encoding: utf-8

module SportDb

class Builder

  include LogUtils::Logging

  def initialize()
    @datasets = []
  end

  def self.load_file( path='./Datafile' )
    code = File.read_utf8( path )
    self.load( code )
  end

  def self.load( code )
    builder = Builder.new
    builder.instance_eval( code )
    builder
  end


  def football( name, opts={} )
    logger.info( "[builder] add football-dataset '#{@name}'" )
    @datasets << FootballDataset.new( name, opts )
  end

  def world( name, opts={} )
    logger.info( "[builder] add world-dataset '#{@name}'" )
    @datasets << WorldDataset.new( name, opts )
  end


  def run()
    logger.info( "[builder] begin - run" )
    download()   # step 1 - download zips for datasets
    read()       # step 2 - read in datasets from zips
    logger.info( "[builder] end - run" )
  end

  def download()
    logger.info( "[builder] dowload" )
    @datasets.each do |dataset|
      dataset.download()
    end
  end

  def read()
    logger.info( "[builder] read" )
    @datasets.each do |dataset|
      dataset.read()
    end
  end

end # class Builder
end # module SportDb
