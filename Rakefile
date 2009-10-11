require 'rubygems'
require 'rake'
require 'spec/rake/spectask'

namespace :spec do
  desc "Run unit specs"
  Spec::Rake::SpecTask.new(:unit) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_opts << '--color' << '--format nested'
    spec.spec_files = FileList['spec/unit/**/*_spec.rb']
  end

  desc "Run regression specs"
  Spec::Rake::SpecTask.new(:regression) do |spec|
    spec.libs << 'lib' << 'spec'
    spec.spec_opts << '--color' << '--format nested'
    spec.spec_files = FileList['spec/regression/**/*_spec.rb']
  end
end

desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts << '--color' << '--format nested'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end