# UalaCodeChallenge


### Approach used:
Basically I've started by reading various times the specifications making sure that I've understood as best as possible and making a mental map about how to develop it. 
Then I've started splitting the app into smaller Features, like `NetworkClient`, `CitiesRepository`, `MainView`, `MapView`, `SearchBar`, etc. 
I've decided to start with layers more related to `Logic` and leave the `Presentation` layers to latter steps (you can check this by looking at the commit history).
Each feature was developed alongside it's Unit Tests, in order to detect any error or necessary refactor on early stage and not build on top of shaky foundations. 
Same for `Views`, they were first "made to work" and then refactored to take advantage of composition, remove any logic that could be moved to `ViewModels` and make them more readable. 
UI Tests were left for the last step. This is a decition I've made based on the fact that in my experience I've always tested using Appium (too long to setup and overkill for a code challenge). As I had to investigate a bit how to made them natively, I've left them to the end, in favor of prioritizing features and chores I was sure I'd be able to finish. 
### Decisions and Asumptions:
For design patter I've decided to go with MVVM, due to being a good fit for integration and communication with SwiftUI. 
I've complemented it with a layer architecture, in order to keep responsibilities clear. This layers were implemented using protocol injection, to make them testable via mocking. 
Said layers were:
 - Networking Layer: responsible of doing all the calls to the API, logging and error handling. 
 - Repository Layer: responsible of fetching the data, in this case using the network layer. 
 - Service Layer: the service represents an action, in this case GET cities. It works with the Repository to acchieve that, but the Repository can be changed for a different one that goes to a database for example, wihotuh messing with the underneath layers. 
 - Presentation Layer: responsible of interacting witht he user. 

For Persistance I've went with `UserDefaults`. I consider that for this case (storing and array with favorite's ids) is enought, and using `SwiftData` for this would have been overkill. 
### Future improvements: 
In case the app were to scale and become productive, there are various things to improve. Some that comes to mind are: 

 - Unify the colors and constraints used into a `Theme` class, to avoid hardcoding and helping with future maintainability.
 - Add support for translations and more languages. Now `Strings` are hardcoded, ideally we will have a `Translator` class that takes a key and matches that with the user's language. Or translations provided via Backend. 
 - Check if the response/firm is going to grow or stay the same. In case of becoming more complex, `UserDefaults` might not be enough for persistance and it'll be better to migrate.
 - Better logging. The `Logger` class now is super basic, good enough for testing and debugging myself, but for production grade code we should incorporate a tool that allows us to track crashes in real time, like `Firebase`/`Crashlytics`. 
 - Better security. Now the API is accessed by simply calling it. In production we should use APIKeys, securely stored (ie. Apple's Keychain) and establish some sort of authentication or tokens policy (will we use sessions? provide access tokens? after how much will they expire? etc). 
 - Clear and defined pipeline. Now I'm working and pushing to main, main branch should be locked and enforced to go through a PR review process, with code coverage checks, automated builds, tests runs, etc. 
 - Better `Landscape` support. Now I'm relying on GeometryReader as a hacky way of getting the orientation and view sizes. This is not the best approach if we start thinking about other devices like iPads.
 - Make sure to debug views and remove all console warnings related to UI. 
 - Implement a more robust UI testing. By this I mean, use some sort of data source (enums, json) with expected strings, colors, sizes, etc; and make sure that the UI generated in tests match with that. 
