#--
# Copyright (c) 2006-2007 Luis Lavena, Multimedia systems
#
# This source code is released under the MIT License.
# See MIT-LICENSE file for details
#++

require 'rake/packagetask'
require 'rakehelp/freebasic'

PRODUCT_NAME = 'SimpleLogger'
PRODUCT_VERSION = '0.1.1'
RELEASE_NAME = "#{PRODUCT_NAME.downcase}-#{PRODUCT_VERSION}-lib-win32"

# global options shared by all the project in this Rakefile
OPTIONS = {
  :debug => false,
  :profile => false,
  :errorchecking => :ex,
  :pedantic => true
}

OPTIONS[:debug] = true if ENV['DEBUG']
OPTIONS[:profile] = true if ENV['PROFILE']
OPTIONS[:errorchecking] = :exx if ENV['EXX']
OPTIONS[:pedantic] = false if ENV['NOPEDANTIC']

# Package source for distribution
Rake::PackageTask.new(PRODUCT_NAME.downcase, PRODUCT_VERSION) do |p|
  p.need_zip = true
  p.package_files.include 'README', 'CHANGELOG', 'TODO', 'MIT-LICENSE', 'Rakefile', 
                          'doc/**/*', 'lib/**/*.{bas,bi,rc}', 'tests/*.{bas,bi,rc}', 
                          'examples/**/*.{bas,bi,rc}', 'rakehelp/*.rb'
end

# Define FreeBASIC projects
project_task :simple_logger do
  lib         'simple_logger'
  build_to    'lib'
  
  search_path 'lib'
  
  source      "lib/**/*.bas"
  
  option      OPTIONS
end

task "all_tests:build" => "simple_logger:build"
project_task :all_tests do
  executable  :all_tests
  build_to    'tests'
  
  search_path 'lib'
  lib_path    'lib'
  
  main        'tests/all_tests.bas'
  
  # this temporally fix the inverse namespace ctors of FB
  source      Dir.glob("tests/*.bas").reverse
  
  option      OPTIONS
end

desc "Run all the internal tests for the library"
task "all_tests:run" => "all_tests:build" do
  Dir.chdir('tests') do
    sh %{all_tests}
  end
end

desc "Run all the test for this project"
task :test => "all_tests:run"

desc "Package the static lib and the include file, also README for distribution"
task :release_lib => ["simple_logger:build", :test] do
  mkdir_p "release/lib/win32"
  mkdir_p "release/inc"
  mkdir_p "release/examples/SimpleLogger"
  mkdir_p "release/docs/SimpleLogger"
  cp "lib/libsimple_logger.a", "release/lib/win32"
  cp "lib/boolean.bi", "release/inc"
  cp "lib/simple_logger.bi", "release/inc"
  cp "examples/simple_test.bas", "release/examples/SimpleLogger" rescue nil
  ['README', 'CHANGELOG', 'MIT-LICENSE'].each do |f|
    cp f, "release/docs/SimpleLogger"
  end
  chdir "release" do
    sh "zip -r #{RELEASE_NAME}.zip ."
  end
end

task :clobber_lib do
  rm_r "release" rescue nil
end 
task :clobber => :clobber_lib
