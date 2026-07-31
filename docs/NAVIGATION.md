# Navigation and daily learning

NilaSpeak now uses a five-destination Flutter shell: Dashboard, Learn, AI Tutor, Progress, and Settings. The shell is the authenticated and local-first application surface; the router redirects a completed local profile to `/dashboard` and an incomplete profile to onboarding.

Android back behavior is intentional:

- from a nested screen, back pops to its parent;
- from Learn, Settings, or another shell root, back returns to Dashboard;
- from Dashboard, back is allowed to exit the application;
- Settings opens profile, placement, and account screens with push navigation so back returns to Settings.

The Dashboard exposes Continue Day N, the daily learning path, progress, AI Tutor, learning plan, and mistake notebook. Voice and speech features remain outside the current scope.
