require 'rubygems'
require 'spec'
require 'spec/rake/spectask'

namespace :spec do
	desc 'Run specs'
	Spec::Rake::SpecTask.new(:run) do |t|
		t.spec_opts << '--require' << 'lib/processing_formatter'
		t.spec_opts << '--format ProcessingFormatter'
		t.spec_files = Dir.glob(File.join(File.dirname(__FILE__), 'spec/**/*_spec.rb'))
	end
end

desc 'Run specs'
task :spec => 'spec:run'

