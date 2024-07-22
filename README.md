# Observatory
<img src="ObservatoryLogo.png" alt="logo" width="450" height="450">

A swift written distributed tracing and log clinet built conformimg to **OpenTelemetry**'s specifications

*For details of opentelemetry, go to [here](https://opentelemetry.io/docs/what-is-opentelemetry/)*

## What it does?

### DemoScenario

​	Here's an example of user activity. In this show case, the user has done following actions:

* Enter trace page
* Segue to another page
* Press a button and segue to another page
* view a table list, select one of the item
* An alert is shown, the user tapped OK

<img src="Observatory_Demo.gif" alt="showcase" width="325" height="712">

### Data Browse

Here's the distributed tracing data collected in an Zipkin backend, by searching the trace ID the developer can look into details when the App is used by the user. Including:

*  Each span duration
* Attribute added to the span
* Event happend during the span period

<img src="Observatory_bakend.png" alt="backend" width="1080">

### summary

​	In short, To help application developer to improve the observability of their apps. By offering distributed tacing data to the backend colletor, developer can see through the connection between logs and understand the hole process they defined rather than searching in tons of god knows wether they are relative logs and die trying to organize the whole situation.

​	when the distributed tracing data sent to backend, in a Grafana backend would looks like this:

<img src="opentelemetryDataCase.png" alt="showCase" width="700" height="800">

You can monitor each span you defined and created, how they relate to one and other, what futher information they carry.

## Features

* Pure Swift coding
* MacOS/iOS support
* iOS 10+ compatible
* Logging & Distributed Tracing functions available
* Defualt **Zipkin** support
* Cocoapods & SPM intergration support

* And more!

## Installation

### Cocoapods

Observatory is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Observatory'
```

Alternatively, you can intergrate the module only if it's what you need:

````shell
pod 'Observatory/ObservatoryTracing'
````

For default **Zipkin** implementation:

````shell
pod 'Observatory/ObservatoryTracingZipkin'
````

### SPM

Add your GitHub account and install Package from xcode

Like Cocoapods, SPM offers 4 moudles for developer to import

`ObservatoryCommon`, `ObservatoryLogging`, `ObservatoryTracing`, `ZipkinExport`

## Usage

### Cocoapod Demo

1. For cocoapods intergration and example, **clone** this repository and navigate to `Example/SFRoleDriverModels.xcworkspace`
2. Use the commandline and run command `pod install` (Assuming you already installed Cocoapods)
3. Run the `SFRoleDriverModels.xcworkspace` with **XCode**

### SPM Demo

1. For SPM intergration and example, **clone** this repository and navigate to `ObservatorySPMExample/ObservatorySPMExample.xcodeproj`
2. Simplly Run the project with **Xcode**

## Author

RavenDeng dlfkid@icloud.com

## License

Observatory is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
