### Reactive Qapital Demo App
A simple demo app that shows some of the patterns used at Qapital for Reactive Programming.

To get started run
```sh
carthage bootstrap --platform ios
```
The repo also includes a small Sinatra http server so start that with
```sh
ruby ReactiveServer.ru
```
You should now be able to run the sample app against the local server.

### References
An introduction to Reactive Programming
https://gist.github.com/staltz/868e7e9bc2a7b8c1f754

Illustrates how the different operators work. This shows the names of the operators
in RxSwift but most names match in ReactiveSwift.
http://rxmarbles.com

A video of the talk can be found [here](https://www.facebook.com/cocoaheadssthlm/videos/1803840123264981/)
