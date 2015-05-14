# VISCERAL Annotation Ticketing Framework
The VISCERAL Annotation Ticketing Framework provides a backend and frontend component to manage the distribution of annotation tickets of multiple structures to multiple annotators.

The framework is build on three components:
   - MySQL DB (create functions in ./db/) to store tickets, annotators,...
   - Webinterface, as frontend for annotators to submit annotations and quality checks (./frontend/visceral/)
   - Matlab backend to manage, distribute and modify tickets (./matlab_backend/)


Login information for the [demo verison][ticketing_demo] of the web interface is given on request from [Markus Krenn][contact_mkrenn].

Installation guidelines to set up the whole framework can be found in InstallationGuidelines.rtf of this repository.


[ticketing_demo]: https://www.cir.meduniwien.ac.at/visceral/tickets/demo/tickets/login.php
[contact_mkrenn]: http://www.cir.meduniwien.ac.at/team/markus-krenn/