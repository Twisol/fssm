class FSSM::Backend::Polling < FSSM::Backend::Build :polling
  usable_when {true}
  
  defaults {:latency => 1.5}
  
  preinit do
    @state = FSSM::ManagedState.new
    @state.update_patterns(@patterns)
    @state.update_paths(@paths)
  end
  
  difference do
    @state.build_difference do
      update_patterns(@patterns)
      update_paths(@paths)
    end
  end
  
  run_loop do
    start = Time.now.to_f
    handler
    nap_time = latency - (Time.now.to_f - start)
    sleep nap_time if nap_time > 0
  end
end
