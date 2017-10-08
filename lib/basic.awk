## check if element (needle) is part of array (haystack)
function inArray(needle, haystack,   x, y) {
  for (x in haystack) y[haystack[x]]
  return(needle in y)
}

#function inArray(needle, haystack,    h) {
#  for (h in haystack)
#    if (h == needle) return 1
#  return 0
#}

## return the size of an array
function sizeof(arr,   n, i) {
  n = 0; for (i in arr) n++;
  return(n);
}

## return a random key from an (associative)array
function randkey(arr,   n, i) {
  n = int(rand() * sizeof(arr))
  for (i in arr) if (!n--) return(i)
}

## check if a file exists (and can be read)
function exists(file,   junk) {
  if ( (getline junk < file) > 0 ) {
    close (file)
    return 1
  }
  return 0
}

## strip leading/trailing spaces and double-quotes
function strip(str) {
  gsub(/^ *"?|"? *$/, "", str)
  return(str)
}

## returns the systems uptime in seconds with 2 decimal places
function preciseTime() {
  getline < "/proc/uptime";
  close("/proc/uptime");
  return($1);
}

## sort functions used in PROCINFO["sorted_in"] for array printing
## sort based on key/index
function cmp_idx(i1, v1, i2, v2,   n1, n2) {
  n1 = i1 + 0
  n2 = i2 + 0
  if (n1 == i1) return (n2 == i2) ? (n1 - n2) : -1
  else if (n2 == i2) return 1
  return (i1 < i2) ? -1 : (i1 != i2)
}

## sort based on value
function cmp_val(i1, v1, i2, v2,   n1, n2) {
  n1 = v1 + 0
  n2 = v2 + 0
  if (n1 == v1) return (n2 == v2) ? (n1 - n2) : -1
  else if (n2 == v2) return 1
  return (v1 < v2) ? -1 : (v1 != v2)
}

