require 'rubygems'
require 'rake'

gem 'rdoc'
gem 'rspec'
require 'rdoc/task'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['-r ./spec/spec_helper']
  t.verbose = true
end

gem_spec = Gem::Specification.load(Dir['*.gemspec'].first)
gem_pack = Gem::PackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

RDoc::Task.new('rdoc') do |t|
  t.rdoc_files.include( *gem_spec.extra_rdoc_files, 'lib/**/*.rb')
  t.main = 'README'
  t.title = gem_spec.description
end
