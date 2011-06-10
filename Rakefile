require 'rubygems'
require 'rake'

gem 'rspec'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = %w[--color]
  t.verbose = true
end

require 'rake/gempackagetask'
gem_spec = Gem::Specification.load('Gemspec')
Rake::GemPackageTask.new(gem_spec) do |pkg|
  pkg.need_zip = false
  pkg.need_tar = false
end

if gem_spec.has_rdoc
  require 'rake/rdoctask'
  Rake::RDocTask.new('rdoc') do |t|
    t.rdoc_files.include( *gem_spec.extra_rdoc_files, 'lib/**/*.rb')
    t.main = 'README'
    t.title = gem_spec.description
  end
end
