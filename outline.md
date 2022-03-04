# Introduction to FOLIO

Introductory talk for LoC technical staff.  
Friday 4 March 2022, 9am Eastern time.



## Session 1: FOLIO Architecture (30 minutes)

* **SLIDE: title, author, affiliation**
* A FOLIO instance supports multiple tenants
  * Tenants are completely isolated from each other
  * From now on we will only consider what happens within a single tenant
* FOLIO is made up of modules
  * Back-end module and Front-end modules work very differently
  * We will mostly be talking here about back-end modules
  * **SLIDE: a FOLIO system with Stripes, Okapi, front-end and back-end modules**
* Ubiquitous use of JSON-based WSAPIs
  * Okapi is itself controlled by a secured WSAPI
  * **SLIDE: example JSON WSAPI request/response pair**
  * **LIVE DEMO: login and search for instances**
* Modules provide and consume interfaces
  * **SLIDE: example provide/require/optional network**
* Okapi moderates all access to modules
  * From inside (one module calling another)
  * From outside (e.g. the UI)
  * From third-party clients, e.g. the Z39.50 server
  * **SLIDE: FOLIO system (as before) with call topology added**
* The permissions model
  * Atomic permissions
  * Permission sets
  * Trees of permission sets
  * **MAYBE SLIDE: DAG of permission sets**
  * Modules' use of permissions:
    * Required permissions
    * Desired permissions
    * Module permissions
  * Enforced by Okapi (actually by mod-permissions) except desired permissions



## Session 2: FOLIO development (30 minutes)


### Developing backend modules (15 minutes)

* A module can be written in any language
  * We have modules in Java, Node, Groovy, Perl, maybe others
* A program is a FOLIO module if it fulfils specific criteria:
  * Provides functionality via WSAPIs
  * Describes these WSAPIs in a module descriptor
  * Supports a "health check" WSAPI `/admin/health` responding 200 OK
* This means an existing WSAPI may be a FOLIO module if you create a descriptor
* Flexible tooling opens up lots of ways to do things
  * We tend to run modules inside containers but that is not required
  * UI development can be done against a public server
  * Back-end development using a reverse-tunnel out of a VM
  * **SLIDE: diagram of reverse-tunnel VM approach**
  * John will say _much_ more about deployment
* Most modules are in Java due to tooling support (RMB, Spring Way)
* Quality control?
  * Mechanism, not policy
  * Flower releases are extensively QA'd
  * Other mechanisms for running modules from self, peers, vendors


### Developing UI modules within Stripes (15 minutes)

* Unlike back-end modules, UI modules are compiled into a single bundle
  * **SLIDE: screenshot of FOLIO highlighting the choice of apps**
* The framework that builds and supports the bundle is Stripes
* Stripes modules (= UI modules) are implemented as Node packages using React
  * There is no polyglot option as with back-end modules
  * ... except languages that Babel can handle (e.g. TypeScript)
* A Node package is a Stripes module if it fulfils specific criteria:
  * The module exports a single React component which Stripes invokes in various different ways
  * Its package file must contain a `stripes` section containing:
    * An `actsAs` entry (app, settings, plugin, handler, etc.)
    * `okapiInterfaces` specifies what back-end interfaces the module uses
    * permissions
  * A `translations` directory
* Extensive support is provided by the Stripes framework



