class FSSM::Backend::RubyCocoa < FSSM::Backend::Build :rubycocoa
  usable_when do
    begin
      require 'osx/foundation'
      OSX.require_framework '/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework'
      true
    rescue LoadError
      false
    end
  end
  
  defaults {
    :latency => 1.5,
    :since => OSX::KFSEventStreamEventIdSinceNow
  }
  
  preinit do
    @state = FSSM::ManagedState.new
    @state.update_patterns(@patterns)
    @state.update_paths(@paths)
  end
  
  init do
    directories = []
    @patterns.each {|p| directories.push(p.path)}
    @paths.each do |path|
      pn = FSSM::Support::Pathname.for(path)
      pn.directory? ? directories.push("#{path}") : directories.push("#{pn.dirname}")
    end
    directories.uniq!
    
    @fsevent = Rucola::FSEvents.new(directories, @options) do |events|
      changed_paths = events.map {|event| event.path}
      handler(changed_paths)
    end
    
    @fsevent.create_stream
    @fsevent.start
  end
  
  difference do |changed_paths|
    @state.build_difference do
      update_paths(changed_paths)
    end
  end
  
  run_loop do
    begin
      OSX.CFRunLoopRun
    rescue Interrupt
      @fsevent.stop
    end
  end
end
