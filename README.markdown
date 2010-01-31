DSL API
=======

So far, the idea for the DSL API is to allow mixed file/directory events more cleanly, for collecting events rather than firing absolutely everything off one file at a time, and configuring the backend with optional auto-selection. This is the current idea for the new API:

    # I like the current mixed context blocks for configuration... you can either 
    # let it eval in context, or use a block parameter so that it doesn't eval 
    # (and you can use variables from outside the block, etc). I'll use the block 
    # parameter form here for clarity.

    FSSM.monitor do |monitor|
      # auto-select backend
      monitor.backend :auto do |backend|
        backend.latency 1.5
      end

      # use backend plugin that registered itself as 'inotify',
      # raising an exception if that backend is unavailable on this
      # platform.
      monitor.backend :inotify

      # backend type would use default 'auto' here
      monitor.backend do |backend|
        backend.latency 1.5
      end

      # these two are equivalent
      monitor.backend do |backend|
        backend.choose :poll
        backend.latency 1.5
      end
      monitor.backend :poll do |backend|
        backend.latency 1.5
      end
  
      # group together a collection of directories and/or files so that they can
      # report their events to the same callback handler.
      monitor.group do |group|
        group.directory '/some/directory/', '**/*.md'
        group.directory '/some/other/directory/', '**/*.md'
        group.file '/some/file.md'
    
        group.collect {|events|}
      end
  
      # watching children of a directory for specific events
      monitor.directory '/some/directory/' do |directory|
        directory.glob '**/*.yml'

        directory.create {|directory, relative, event|}
        directory.update {|directory, relative, event|}
        directory.delete {|directory, relative, event|}
      end

      # watching children of a directory, collecting events per
      # latency period
      monitor.directory '/some/other/directory/' do |directory|
        directory.collect {|events|}
      end

      # path is a compatibility alias for directory
      monitor.path '/some/path' do |path|
        path.update {|directory, relative, event|}
      end

      # watching a specific file for specific events
      monitor.file '/some/file' do |file|
        file.create {|full_path, event|}
        file.update {|full_path, event|}
        file.delete {|full_path, event|}
      end

      # watching a specific file, collecting events per latency 
      # period
      monitor.file '/some/file' do |file|
        file.collect {|events|}
      end
    end


Backend API
===========

I havent a clue yet. Thinking about it. ^\_^

# ...maybe?

    module FSSM::Backend
      # backend classes must inherit from FSSM::Backend::Base
      class ExampleBackend < Base
        # the configuration key for this backend
        key :example
    
        # a usability check to determine whether this backend is usable
        usability_check do |env|
          # the env block parameter contains a hash of useful info about
          # the current environment. I'm thinking about changing this.
          # {:jruby=>true, :os=>"darwin", :mac=>true, :linux=>false}
          env[:jruby] && env[:mac] && begin
            require 'java'
            require 'some_other_essential_library'
            true
          rescue LoadError
            false
          end
        end
    
        # pre-configured handler object currently unspecified
        # a handler will be an API back into the monitor library
        def add_handler(handler)
          # handler.groups maybe?
        end
    
        # start run loop
        def run
        end
    
      end
    end
