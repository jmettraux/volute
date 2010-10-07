
require 'lib/volute.rb'

require 'rubygems'
require 'rake'


#
# SPEC

task :spec do
  sh "spec -cfs spec/"
end

task :default => :spec


#
# CLEAN

require 'rake/clean'
CLEAN.include('pkg', 'tmp', 'html', 'rdoc')


#
# GEM

require 'jeweler'

Jeweler::Tasks.new do |gem|

  gem.version = Volute::VOLUTE_VERSION
  gem.name = 'volute'
  gem.summary = 'placing some [business] logic outside of classes'

  gem.description = %{
placing some [business] logic outside of classes
  }
  gem.email = 'jmettraux@gmail.com'
  gem.homepage = 'http://github.com/jmettraux/volute/'
  gem.authors = [ 'John Mettraux' ]
  gem.rubyforge_project = 'rufus'

  gem.test_file = 'test/test.rb'

  #gem.add_dependency 'mime-types', '>= 1.16'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'jeweler'

  # gemspec spec : http://www.rubygems.org/read/chapter/20
end
Jeweler::GemcutterTasks.new


#
# DOC

#
# make sure to have rdoc 2.5.x to run that
#
require 'rake/rdoctask'
Rake::RDocTask.new do |rd|

  rd.main = 'README.rdoc'
  rd.rdoc_dir = 'rdoc/volute'
  rd.title = "volute #{Volute::VOLUTE_VERSION}"

  rd.rdoc_files.include(
    'README.rdoc', 'CHANGELOG.txt', 'lib/**/*.rb')
end


#
# TO THE WEB

task :upload_rdoc => [ :clean, :rdoc ] do

  account = 'jmettraux@rubyforge.org'
  webdir = '/var/www/gforge-projects/rufus'

  sh "rsync -azv -e ssh rdoc/volute #{account}:#{webdir}/"
end

