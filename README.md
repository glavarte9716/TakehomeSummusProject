# TakehomeSummusProject
Thank you for taking the time to look at my version of your project.
Full disclosure, I put over 10 hours of effort into this mostly due to the constraints, the planning of my architecture, and trial and error.
I had never made an entire app with no storyboards, and I have never used SwiftUI. I enjoyed stepping out of my comfort zone, but forgive me that I did not have time to think about style or design, which is something I usually put more thought into. I hope to discuss more! :)

Architecture: 
Fast and easy attempt at a reactive system.
The data flow is intendended to be as unidirectional as possible. 
My view controller's are not intended to maintain the accurate state of data.
They maintain reference to a CurrentValueSubject that is responsible for receiving updates on the state changes.

