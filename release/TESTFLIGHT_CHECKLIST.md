# Questly TestFlight Checklist

## Pre-Archive
- [ ] Set a unique production `PRODUCT_BUNDLE_IDENTIFIER`
- [ ] Confirm `MARKETING_VERSION` and increment `CURRENT_PROJECT_VERSION`
- [ ] Verify app icon and launch screen assets are present
- [ ] Confirm signing team/profile in Xcode target settings

## Build Validation
- [ ] `xcodebuild ... build` succeeds
- [ ] `xcodebuild ... build-for-testing` succeeds
- [ ] `Cmd+U` runs tests on a concrete simulator in Xcode

## Functional Smoke Test
- [ ] Create task in each section (Morning/Midday/Evening/Inbox)
- [ ] Move tasks between sections and dates
- [ ] Edit title/details/priority/reward/daypart and verify persistence after relaunch
- [ ] Complete and delete via swipe actions
- [ ] Search and completion filters update sections correctly
- [ ] Recurring completion generates next occurrence correctly
- [ ] Reminder enable/disable works from create/edit
- [ ] Notification denied flow shows guidance in Settings
- [ ] Reset local data clears tasks and relaunch remains empty

## Release Ops
- [ ] Fill TestFlight release notes
- [ ] Fill App Store metadata draft
- [ ] Upload archive and distribute to internal testers
