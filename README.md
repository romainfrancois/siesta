siesta
======

Generic Tools to work with REST apis

```
library(siesta) 

github <- json_api( "https://api.github.com/" )
github_issues <- github$bind( "repos/:user/:repo/issues" )
grab( github_issues( "hadley", "dplyr" ) , 
  number, 
  login = user$login, 
  title,
  labels = paste( sapply( labels, "[[", "name" ), collapse = ", " )
)
```

