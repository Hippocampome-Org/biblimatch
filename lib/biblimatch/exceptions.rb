module Biblimatch

  class NoMatchError < StandardError
  end

  class NoHippocampomeMatchError < NoMatchError
  end

  class NoPubmedMatchError < NoMatchError
  end

end
