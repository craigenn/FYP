library(shinythemes)
library(h2o)
h2o.init(nthreads = 4)
onStop(function() {
  h2o.shutdown(prompt = FALSE)
})