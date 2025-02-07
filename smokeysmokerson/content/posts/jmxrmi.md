---
title: "Implement JMX RMI in Golang"
date: 2025-02-20T23:01:49+05:30
draft: true
HideMeta: true
ShowBreadCrumbs: true
ShowReadingTime: true
showtoc: true
---

## Introduction

A quick background, So in my day job, I work as a platform engineer who has to work with both Java and Golang. We use `jmxtrans` for fetching JMX Metrics of a hadoop service, filter and parse and push to db. I searched for a long time for an alternative of `jmxtrans` in either golang or rust. I couldn't find any such libraries or application which will use native implementation of the RMI protocol. Instead I have found applications/cli which uses jmxrmi client in java and then send the data over as JSON.

Now a days I am learning TCP and its internals. I have been doing some small small projects on writing custom TCP protocol both in binary and string. Now its time to implement the JMX RMI Protocol in native Golang which will use a Java Object Serialization impl from scratch.
