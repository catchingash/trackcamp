# Project Plan: TrackCamp (TC)

## Target Audience ##
  TC's target audience are individuals who wish to gain more insight into their individual health and wellbeing. They are motivated by large, overwhelming issues, like chronic fatigue, and are looking for information about how changes in their behavior can help them.

### Problem Statement ###
  **We are not the averages of our peers**. Every single one of us is unique, and we will respond to some things more than others. When trying to gain insight and make decisions about what affects **an individual's** health and wellbeing, it can be easy to feel overwhelmed and powerless. TC is a tool to help individuals organize data about themselves in an organized fashion, so that they can build better user's manual for their bodies.

### Market Research ###

#### Alternatives to TC ####
- Physician-guided exploration.
  - TC is not intented to replace medical guidance. Hopefully, it can merely supplement. From personal experience, doctors appointments are short, and they need _data_ just like anyone else; all of us are our own conglemeration of similar-yet-different cells, with different responses. They can (and often do) make suggestions about what works for "some" people, but they cannot guarantee that it will work for any specific patient. This can provide more information for the patient, and for the doctor, about what happens when the patient makes specific changes.
- [Mymee](http://www.mymee.com/): medically-supervised self tracking. It is an app that allows doctors to track information about their patients, and then use that to make diagnoses or recommendations. Individuals cannot access the app without a doctor.
  - What if your doctor doesn't use Mymee?
  - What if you don't have a problem that requires constant medical guidance?
  - TC puts the power in the hands of the individual, and allows them to decide what's important and what isn't.
- [Saga - The Essential Lifelogging App](https://itunes.apple.com/us/app/saga-essential-lifelogging/id611593488?mt=8) -- iOS only.
  - It's unclear from the previews, but it does not appear to provide a data visualization / ability to display more than one attribute at a time.
  - It is only available for iOS.
- [Fluxtream](https://fluxtream.org/): An open-source, non-profit personal visualization framework from the [BodyTrack Team](http://www.cmucreatelab.org/projects/BodyTrack) @ CMU CREATE Lab & Candide Kemmler.
  - It integrates with primarily hardware-dependent apps: things like Jawbone Up, FitBit, and BodyMedia. While these are valuable, it limits the accessibility and use of Fluxtream.
  - It also doesn't support self-entry.
- [TicTrac](https://tictrac.com/): "Tictrac is a digital health platform that engages people in their health through their unique data. Today, our platform is used by the world’s leading Healthcare, Pharmaceutical, and Telecommunications companies."
  - It is not available to the general public.
  - TC is available to anyone.
- [Ginger.io](https://www.ginger.io/): "Today, we're using the Ginger.io platform for patient support at partner institutions and research into a select number of conditions."
  - Includes surveys (like the PHQ-9), location tracking, communication tracking, etc.
  - Only available if one's health care provider is using it, or if they fit into certain research studies.
  - TC is available to anyone.
- [Addapp](https://addapp.io/)
  - It analyzes data and gives tips, but it does not appear to focus on letting the individual draw their own conclusions.
  - iOS only

#### User Personas ####
- The target user:
  - Is willing to devote some time to the issue, but has a busy/hectic life. Cannot expect them to be able to make consistent, systematic changes while maintaining everything else in a perfectly consistent manner (e.g. "Try getting exactly 9 hours of sleep for a week, but be sure to eat the exact same thing every day and the exact same time!"). Users will also have little time to create their own graphs.
    - TC will allow the user to track the ups and downs, and see how multiple things changed.
    - TC will integrate with other apps that automate and streamline the tracking process as much as possible. For example, Google Fit passively tracks most types of physical activity, and allows for quick input of others.
  - Is analytical.
    - The app will provide them the graphs and information to draw their own conclusions.
    - It's easy to overthink things -- that's why it's good to be as objective as possible. The app will provide as many objective measures as possible.
    - The initial deployment will be a web app, so that users can load browser-heavy graphs and can see multiple graphs at once.
  - Owns a mobile device.
    - For the initial version, the app will integrate with several other tracking apps. This will provide consistent data, as well as streamline/automate the tracking as much as possible.
  - Owns an Android device.
    - There are several tracking apps on iOS, but the target demographic here will be Android users, since there seems to be a larger void in this market.
  - Has limited tracking experience.
    - Those who have been extensively tracking their data for years will likely have outgrown the initial version of TC. TC is intented to help the struggling newcomer.
    - TC will provide specific advice and directions for how to use the app, as well as which supporting apps are recommended and how to use them.
  - Is looking for the big, obvious changes, not the fine-grained details.
    - If someone is looking for ways to improve their mile time by a few seconds, and the changes necessary to do so are very detailed, then this app is not for them. TC is for those who have larger "problems", e.g. are constantly exhausted, and are wondering if things like exercising more will help... but are less concerned about what exact exercises get them there.
  - Is not ready for financial investments into this.
    - It can be difficult for some people to commit to high up-front costs, especially when those costs may not be necessary or helpful to their personal changes.
    - All integrations will be with free apps.
    - No hardware purchases will be necessary.

## Project Spec ##
- TC will provide a quick tutorital of how to use TC.
- TC will support tracking of data, and will provide views of each individual data type (e.g. sleep). TC will support tracking of the following:
  - Sleep (duration, quality (self-reported), timing) (via SleepBot)
  - Food (pictures) (via web hardware integration?! JS)
  - Weight (via Google Fit)
  - General activity levels (via Google Fit)
  - Mood (via MoodPanda)
- TC will provide instructions for how to use each app.
- TC will provide at least one integrated data visualization view that will bring together data from all tracking sources.
- TC will provide at 1+ data visualization methods (e.g. line graphs, pie charts).
- TC will provide customizable data display, allowing users to customize what/how data is displayed.
- TC will support manual input of data (i.e. 3rd-party apps will not be required).
- TC will attempt to POST data to the 3rd party apps, allowing users to access their data where and how they would like.
- TC will provide users ownership of their own data -- users will be able to download their data and delete their accounts (which will fully remove all of their information from TC) at any time.
- TC will be HIPAA compliant, where applicable. TC will avoid collecting unnecessary identifying information.

## Delivery Plan ##
- **Oct 9**
  - Product Plan
  - App Name + logo
  - Domain name (selected + purchased)
  - First draft of site description/goals
  - Skeleton Rails app + views
  - PSQL set up
  - Google OAuth implemented
  - Google Fit API integrated (GET, POST?)
  - Integrate Food logging
  - SSL?
- **Oct 16**
  - Integrate Sleep tracking
  - Come up with overarching front-end design
  - Implement JS framework
  - D3 visualization
- **Oct 23**
  - Send signup confirmation emails
  - Integrate Mood tracking
  - Hosted on EC2, using S3 for storage/delivery
  - Confirm design consistency across the site
- **Oct 30**
  - Final, completed application, live on the web
  + The source code of your project on Github, with:
    + Clear documentation on how to setup/install the project
    + Any third-party dependencies or configuration required
    + A link to the Trello board
    + A link to the Product Plan
  + Project presentation, a demo of the application and product plan
  - Finalize user how-to instructions
  - Finalize README


  - Each of the data type = its own deliverable.
  - Then the intersection of the data is the D3 stuff to integrate them.
  - Ask Jeremy about the D3 book recommendation

### Goals & Guidelines
+ Use your product plan to lead the functionality development of their application
+ Create and maintain a [Trello board](https://trello.com/) to document progress on your project.
+ Host the application using a VPS such as Amazon EC2
+ Configure DNS with custom domain
+ Create a stylized, responsive design for all devices (phone, tablet, display)
+ At least 10 items of seed data for each concept/model
+ Use background jobs for any long running tasks (email, image processing, 3rd party data manipulation)
+ Use caching for slow or bulky database interactions
+ Use performance analytics to asses and optimize site performance (average server response time < 300ms)
+ Practice TDD to lead the development process
+ Integrate email (At least user signup)
+ Expectations for code quality:
  + 90% or greater test coverage (models and controllers)
  + Javascript tests (client and server side) w/ Mocha
  + B- or greater score on Code Climate
  + No security issues (Brakeman)

### Integration Choices
+ Choose at least two complex integrations, examples:
  + Background/Async Jobs (sending emails, confirming registrations)
    - SMS/MMS (via [Twilio](https://www.twilio.com/))
    - Emails
  + Front-end Framework (Ember, Angular, Backbone, etc.)
    - Angular or Backbone
  + Third-party OAuth (logging in w/ Twitter, Github, etc.)
    - Users will be able to log in using their [Google](https://developers.google.com/identity/sign-in/web/) account.
  + ~~NoSql (MongoDB)~~
    - Because of the nature of this project, a relational database makes more sense.
  + ~~Content Delivery Network (CDN)~~
  + ~~Payment Processing (Stripe)~~
    - While users have a lot to gain to use this (and only the highly motivated will stick with it), I also do not want to put my users in a situation where they have to make a decision between saving money or trying something new that may help them. Consequently, this will remain free.

### Advanced Feature Choices
+ Choose at least two advanced features, examples:
  + S3 storage/delivery
  + Secure Socket Layer (SSL) _lose about a day to this_
    - This is, of course, essential.
  + ~~Service Oriented Architecture (SOA)~~
    - TODO: Decide if I really want to skip this.
  + ~~Secure Public API (documented)~~
    - TODO: Decide if I really want to skip this.
  + ~~Content Management System (CMS)~~
  + ~~Internationalization (i18n)~~
  + ~~Live Events (notifications, live updates, think back to Philip's AWS presentation)~~

EC2 won't be a big deal
D3 - their blog has tons of code examples (they're not super accessible, but technically very deep and complex)
D3 - doesn't play nicely. Won't use D3 module into a backbone controller. Backbone renders a template, which then contains a standalone D3 implementation.

React (JSX is a nice templating language) handles templates nicely and listens for events and responds by populating the appropriate JSX template. MIGHT play nicely with D3?
Ember is fun and good but primarily focused at Desktop apps.
Backbone's templating is clunkier than React's.

Single-page gets obnoxious with OAuth. Consider having several server refreshes for OAuth workflow. If it makes sense to reload a page, then reload it. (Perhaps each namespace is a page reload... but a SPA inside that. Makes each SPA its own module to maintain/test.)

### Additional Tech Decisions
- [D3](http://d3js.org/) for data visualizations
- Support for importing CSV data from a few select sources
- Support for exporting all user data from my app
- Using [Google Fit](https://fit.google.com/); importing data through [their API](https://developers.google.com/fit/overview).
- Using [MoodPanda](https://play.google.com/store/apps/details?id=com.MoodPanda); importing data through [their API](http://www.moodpanda.com/api/).
- Using [SleepBot](https://mysleepbot.com/); importing data through their spreadsheet export.
- Resting HR?

- [In Flow - Mood Diary](http://www.inflow.mobi/)

- Need to be careful with timezones! Unambiguous time capturing. Jawbone and BodyMedia include time zone, Fitbit and Flickr are local time without timezone.
- Need to support robust, incremental sync. All data since timestamp isn't sufficient if history is ever changed. Jawbone - all APIs take an updated_after param. Fitbit only does 'best-effort' push notifications.

### Nice-To-Haves
- Provide some basic stats/correlations
- 2-Factor Auth
- More sophisticated tracking / more tracking
- More sophisticated data analysis
- [PhoneGap](http://phonegap.com/) or something similar
- Weather data, from somewhere, using either the user's chosen city or using Google's location data??
- PeriodTracker app or StrawberryPal?
- Track amt of time spent relaxing? Type of relaxation activities?
- Track coffee/tea intake?


Cobal's Guide to Game Design -- a lot of it is about visual information theory. ~40pgs.

D3's Page and Blog. Think about 'what is the illustration? what is the visualization that best informs the intersection of this data, from which the user can see causality'
- Correlation is obvious and should be visible... but causality is harder.

Backend architecture / sevrver. And collecting data. And tests. And seed data.
