# helper functions for HashTable

function has_key(h::HashTable, key)
  return get(h,key,0) == 0 ? false : true
end

function increase_count(h,key)
  if has_key(h,key)
    h[key] += 1
  else
    h[key] = 1
  end
end

function keys(h)
  # thanks to johnmyleswhite for this keys function 
  # https://github.com/johnmyleswhite/JuliaVsR/blob/master/cipher.jl
  h_keys = []
  for e = h
    h_keys = [h_keys, e[1]]
  end
  return h_keys
end

function values(h)
  h_vals = []
  for e = h
    h_vals = [h_vals, get(h,e[1]," ")]
  end
  return h_vals
end

function sum_vals(h)
  sum(values(h))
end