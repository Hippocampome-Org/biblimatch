require 'rb-readline'

module RbReadline

  def self.prefill_prompt(str)
    @rl_prefill = str
    @rl_startup_hook = :rl_prefill_hook
  end

  def self.rl_prefill_hook
    rl_insert_text @rl_prefill if @rl_prefill
    @rl_startup_hook = nil
  end

end
