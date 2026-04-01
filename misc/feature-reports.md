New feature to allow an authenticated user to create a report of their measurement data and made available to non-authenticated (public) users.

### Web App requirements

A new "reports" page in the web-app that lets logged-in users list any previously created reports with a button to create new reports. The create process should let the user choose a date range, which measurements should be included (BP, glucose, etc), and a title for the report. After creation, the report should show up on the list page. Each report should be available to the public with the id in the url, something like: `https://my-site/reports/RMxFU9j1AAHhgXAvS1pf2Bcc3AWr`. The web-app should show the report data with very minimal markup initially -- a subsequent feature will improve upon this.

### Implemenation requirements

The report should be stored in Firestore as a single document with all the information requested. The reports should be created by a Firebase Function. The reports should be in a collection with read-only access from anyone with the link.

### Implementation notes

Ask any necessary clarifying questions before and during implmentation. I like to independently test features during development, so provide me opportunities to do that as you go.
