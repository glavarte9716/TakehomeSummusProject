# TakehomeSummusProject
Thank you for taking the time to look at my version of your project.
Full disclosure, I put over 10 hours of effort into this mostly due to the constraints, the planning of my architecture, and trial and error.
I had never made an entire app with no storyboards, and I have never used SwiftUI. I enjoyed stepping out of my comfort zone, but forgive me that I did not have time to think about style or design, which is something I usually put more thought into. I hope to discuss more! :)

Installation:

1. Clone the repository
2. Open the xcode project file TakeHomeProject.
3. And run the app on a simulator.

I am not sure how much I used is specifically required by the latest Xcode. 
This might not compile on Xcode 13 if some of the code I used now is not available. 

Architecture:

Fast and easy attempt at a reactive system.
The data flow is intendended to be as unidirectional as possible. 
My view controller's are not intended to maintain the accurate state of data.
Instead, ViewController's have Managers.
Manager's have NetworkTargets. (With time I might have made some Protocols for each of these types)
The Manager's have signals or CurrentValueSubjects that are used to hold the state of that data for the screen they are responsible for.
Managers and NetworkTargets communicate via their own signals(CurrentValueSubjects). 
The network targets get initialized with signals for each of the endpoints they request from.
Managers ask NetworkTarget's to fetch data with their functions, Managers manipulate the data and update the ViewController's with their signal. Those signals have an associated type of the ViewModel for that screen. 
Upon receiving an updated viewModel, the ViewController will then render the screen. Loose, but reactive paradigm where the manager's controllerSignals have the true data, and any updates the viewModel will need to be updated on the signals.
