#ls-ios notes

Segments of the code for this challenge are boilerplate-ish but necessary; mostly URLConnection and UITableView related. Given the 2-3 hour time-limit I decided to stay with what is familiar and straightforward.

I decided to use NSOperations and delegation for asynchronous JSON image fetching this allows the TableView to remain responsive while animating or interacting while parsing or downloading occurs. So the bulk of the coding was creating this Asynchronous functionality for parsing the JSON, and Fetching the images and wiring the views and table to work together so that once a request is sent and comes back the view can be updated. I could have also used dispatch_asyc and it's relatives to accomplish similar functionality.

##Some issues as implemented:

The image caching and fetching scheme is not ideal in that requests for the same resource can be dispatched. The repeated avatar is the best example, untill one is downloaded and cached they all get downloadrequests. The active downloads dictionary should be keyed by url and not table indexPaths. That would have made wiring the delegate and ImageFetcher up to the cells tricker and I was already at 2 hours when I realized this.

The current implementation of the NSConnections are brittle, tightly coupled, and would become unwieldy to extend out into say a RESTful api with multiple urls. It would also be useful to, say, instead of getting NSDictionaries back from the JSON parsing to get a collection of "FeedRecord" Core-Data backed objects. This would allow persistence, leveraging sqlite for caching, quick fetches, and a nice centralized Model layer for our MVC. A few open source solutions for this exist. See AFNetworking, RestKit, etc. 

Given the time limit I didn't implement any tests, this is a problem.

##Features to add:

1. Obviously the first would be pull to refresh/get more, this can be added now by just executing the same NSURLrequest that is in the app delegate already. But the sample JSON appears static or is slow to update so I left that out for the time being.

1. Lots more tests Unit Tests etc. There are many good testing frameworks for IOS.

1. A better image caching and loading scheme because performance is a feature.

Links:
github.com/aaroncrespo
stackoverflow.com/users/725403/adc