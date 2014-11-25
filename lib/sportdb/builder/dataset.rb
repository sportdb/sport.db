# encoding: utf-8

module SportDb

class Dataset
  include LogUtils::Logging

  def initialize( name, opts={} )
    @name = name
    @opts = opts
  end

  def setup()
    value = @opts[:setup] || 'all'
    "setups/#{value}"
  end

  def remote_zip_url()  # remote zip url
    "https://github.com/#{@name}/archive/master.zip"
  end

  def local_zip_name()
    ### note: replace / in name w/ --I--
    ##  e.g. flatten the filename, that is, do NOT include any folders
    @name.gsub('/', '--I--')   # note: will NOT include/return .zip extension
  end

  def local_zip_root()
    "./tmp"
  end

  def local_zip_path()  # local zip path
    "#{local_zip_root}/#{local_zip_name}.zip"
  end


  def download()
    logger.info( "[builder] download dataset '#{@name}'" )
    logger.info( "[builder]     from '#{remote_zip_url}'" )
    logger.info( "[builder]     to '#{local_zip_path}'..." )
    
    download_blob( remote_zip_url, local_zip_path )
  end

  ####
  # download tasks for zips
  def download_blob( url, dest )
    logger.info "downloading #{url} to #{dest}..."

    ## make sure dest path exists
    dest_p = File.dirname( dest )
    FileUtils.mkdir_p( dest_p )  unless File.exists?( dest_p )   ## use Dir.exists?? why? why not??

    worker = Fetcher::Worker.new
    worker.copy( url, dest )
    ## print some file stats
    logger.debug "  size: #{File.size(dest)} bytes"
  end

end  # class Dataset


class WorldDataset < Dataset

  def initialize( name, opts={} )
    super( name, opts )
  end

  def read()
    logger.info( "[builder] read world-dataset '#{@name}', '#{setup}'" )

    WorldDb.read_setup_from_zip( local_zip_name(), setup(), local_zip_root(), { skip_tags: true } )
  end
end  # class WorldDataset

class FootballDataset < Dataset

  def initialize( name, opts={} )
    super( name, opts )
  end

  def read()
    logger.info( "[builder] read football-dataset '#{@name}', '#{setup}'" )
  end
end  # class FootballDataset


end # module SportDb
