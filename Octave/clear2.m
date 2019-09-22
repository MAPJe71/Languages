#! octave

# Code: reload octave.rc after clear but keep packages loaded

function clear (varargin)
  args = sprintf (', "%s"', varargin{:});
  evalin ("caller", ['builtin ("clear"' args ')']);
  pkglist = pkg ("list");
  loadedpkg = cell (0);
  for ii = 1:numel (pkglist)
    if (pkglist{ii}.loaded)
      loadedpkg{end+1} = pkglist{ii}.name;
    endif
  endfor
  source ("~/.octaverc");
  if (numel (loadedpkg) != 0)
    pkg ("load", loadedpkg{:});
  endif
endfunction