# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{volute}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Mettraux"]
  s.date = %q{2010-10-12}
  s.description = %q{
placing some [business] logic outside of classes
  }
  s.email = %q{jmettraux@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
     "README.rdoc"
  ]
  s.files = [
    "CHANGELOG.txt",
     "LICENSE.txt",
     "README.rdoc",
     "Rakefile",
     "TODO.txt",
     "examples/diagnosis.rb",
     "examples/equation.rb",
     "examples/light.rb",
     "examples/state_machine.rb",
     "examples/state_machine_2.rb",
     "examples/traffic.rb",
     "lib/volute.rb",
     "spec/apply_spec.rb",
     "spec/filter_not_spec.rb",
     "spec/filter_spec.rb",
     "spec/filter_state_spec.rb",
     "spec/filter_transitions_spec.rb",
     "spec/include_volute_spec.rb",
     "spec/over_spec.rb",
     "spec/spec_helper.rb",
     "spec/volute_spec.rb",
     "spec/volutes_spec.rb",
     "volute.gemspec"
  ]
  s.homepage = %q{http://github.com/jmettraux/volute/}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rufus}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{placing some [business] logic outside of classes}
  s.test_files = [
    "spec/apply_spec.rb",
     "spec/filter_not_spec.rb",
     "spec/filter_spec.rb",
     "spec/filter_state_spec.rb",
     "spec/filter_transitions_spec.rb",
     "spec/include_volute_spec.rb",
     "spec/over_spec.rb",
     "spec/spec_helper.rb",
     "spec/volute_spec.rb",
     "spec/volutes_spec.rb",
     "examples/diagnosis.rb",
     "examples/equation.rb",
     "examples/light.rb",
     "examples/state_machine.rb",
     "examples/state_machine_2.rb",
     "examples/traffic.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end

