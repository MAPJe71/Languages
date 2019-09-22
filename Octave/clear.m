#! octave
# Code: reload octave.rc after clear

function clear (varargin)
  args = sprintf (', "%s"', varargin{:});
  evalin ("caller", ['builtin ("clear"' args ')']);
  source ("~/.octaverc");
endfunction