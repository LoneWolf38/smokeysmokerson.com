---
title: "Hadoop for Beginners"
date: 2025-02-07T16:56:30+05:30
draft: false
HideMeta: false
ShowBreadCrumbs: true
ShowReadingTime: true
showtoc: true
tocopen: false
---
## **What is BigData?**

BigData is nothing, just a collection of large amount of data. Huge data storage was not an issue, just buy hard disks and store data in files. But now if you want to search or just do some calculation on data, you will have huge lag in processing such amount of data. An easier example of such kind of processing can be seen in day to day activities.

> Lets say you have taken some images with your phone camera and you transferred those images/files to a PC. Every data you store around 10 images. At the end of the week you look back on each photo and select the insta worthy images and post them. But searching through the list is tedious task. You want make the search more efficient. Now, before even storing, you rename the images according to a naming convention that helps you to look in a smaller section of large collection. After a few years, you find that your storage is filling up so you get more and more disks but the naming convention you used is defunkt because searching with only the names is a bit hard, so you start adding more context on the names itself so that it is easy to identify which photo to look for. But the storage issue still remains so now you want to delete old images because you have already posted the worthy images to insta. Now you want to _list all the images which are older than a set data_. This is called **data processing**. Now from the list you will delete those images.
Now imagine this scenario in a huge scale. Instead of naming convention, you will start using images meta-data(such as time of the data, size, file_format) as indexes which helps you in searching a large amount of images. Now you want to see some processed data such as how many images are of lower quality and size, filters on meta-data of images. This is nothing but just big data processing.


## **What is Hadoop?**

To manage such huge amount of data and doing processing on such amount is a huge resource intensive effort. A single PC will not be able to process such huge amount. To handle this, hadoop was developed.
Hadoop can be defined in layman's term as "OS For Data". A way of managing and process data with the help of a lot of servers instead of just one. The term data processing is nothing just filtering out and then doing some calculation on top of the filtered out data. As we can see from the above example of big data, once the amount of data has reached a certain amount, you will not be able to do processing on you single PC. You have to get a bigger server, but as the data grows such as your requirement of more resources on the same server. Now with help of Hadoop you can buy smaller servers and can process the data in resource pool combined from the resources of all the small servers you buy.

The concepts of an OS has been implemented by the different services/components of a Hadoop ecosystem.

> **HDFS**: For storing your data across a large amount of servers. A typical File-System implementation of the OS.

> **MR**: The earlier implementation of a Resource Scheduler and an Executor. The OS Scheduler implementation.

> **YARN**: The newer implementation of a Resource Scheduler which combines all the server resources and helps in scheduling the tasks on the Hadoop Stored Data.

---

**Above are the main components of Hadoop. The rest of the components of Hadoop ecosystem are nothing but query engines on different type of data(structured and un-structured).**

---

> HIVE: An SQL based Database which helps in storing and process structured data which can be represented in SQL tables and databases. Behind the scenes the data is stored in HDFS. Queries using HIVE are sent to YARN to be executed in 'containers' across the pool of servers. HIVE uses MR as a query engine.

> TEZ: An query engine which is built on YARN, a better and efficient replacement of MR based queries.

> HBASE: If you want to store some data but don't want to deal with SQL, then HBASE is your friend. HBASE stores data in JSON, which can be categorized as non-relational DB.

> KAFKA: A message queuing system in the Hadoop ecosystem which handles streaming data. Streaming data is nothing just a stream of data that will be passed through one software to another rather efficiently and in low cost to resource.

> ZOOKEEPER: Think about Hashicorp Consul but in Java. It maintains a registry of all the hadoop services and help the clients to manage connections to such distributed applications.

> RANGER: This service handles the authorization of the whole cluster, similar to the `SSSD` service in Linux.

---

**Below are some service which are not usually a part of a Hadoop cluster but are being used by the components/services of the cluster for authentication and user management.**

---


> KERBEROS: This service actually is not a part of Hadoop Cluster but nonetheless an important component of the cluster. Kerberos acts as an authentication service by using time-bound ticketing system for maintaining authentication. Similar to Linux PAM.

> LDAP: This service too is not actually a part of the Hadoop Cluster but plays the part of the user management database in the whole cluster or the whole organization. Similar to the `/etc/passwd` and `/etc/group` files.


## Understanding Hadoop Cluster Architecture.

Let's see how the above components are fitted together to be deployed as a Hadoop Cluster.

First in the list is **HDFS**. Just like the file system in our PCs, HDFS provided a distributed approach to the file storing solution. HDFS provides an similar API for accessing and managing files. All the data that will ever be used in a Hadoop cluster will be stored in the HDFS. HDFS provides replications of data which helps in case of a server failure.  HDFS has internal components which handles managing data in a distributed cluster across many servers. One of such components is Name-node.

**Name-node** is the heart of the HDFS cluster, for bigger Cluster which deals with TBs of data, if a Name-node restart has started it can take up-to few minutes to hours to be functional again. Name-node manages data by using the meta-data to make a layout of the cluster. Name-node controls all the operations ranging from creating files to where to store which file, replications of data and many more. Name-node is the most essential part of a Hadoop system. Name-node maintains a checkpoint in the form of FSImage which is a protobuf file. This file is a binary file which contains all the meta-data of all the files in the cluster. You can also spin up a Secondary Name-node which handles the edit-logs and the checkpoints of the Name-node.

As Name-node is the most important service in the cluster, it's mandatory to have a HA Name-node service which takes over if the active Name-node goes down because of an issue. This service takes place when the active Name-node is down. To achieve this HDFS uses Zookeeper for managing the registry of both the Name-nodes. HA Name-node also uses another service which called Journal-Node service which handles the edit-logs and synchronization between Active and **Standby Name-node**.

Another such component of HDFS is **Data-node**. This service manages the actual data in the servers. Every Data-node service maintains its own replication of the data. Data-node is a slave service in this architecture which basically works as a agent service.

For connecting to HDFS you can use HDFS library written in Java. Another way of connecting to HDFS is to implement the HDFS API in the preferred language by implementing the protocol and the RPC connection details of the Name-node Protocol. There is a library that we use that exactly does the same thing [hdfs in go](https://github.com/colinmarc/hdfs). This library has implemented the protocol as well exposed some of the APIs of the Name-node RPC.

As the HDFS is the most important service in a Hadoop cluster, it should have authentication and authorization in accessing data from the cluster. HDFS achieves this by using Kerberos and Ranger for authentication and authorization respectively. A client if it wants to connect to the Name-node service, has to first get a ticket from the Kerberos Ticket Granting service, after the ticket has been fetched, the user make an API call to the Name-node. Name-node first task is to check if the user making the request has the necessary access privileges to make the request or not. This information is fetched from Ranger service.

---

Next on the list is MR. MR stands for MapReduce which is an execution framework which used by the developers to do data processing in a Hadoop Cluster. MR service in the early days was used for doing data processing in a hadoop cluster by using parallel processing of data. MR uses Mappers and Reducers which in short works by `divide and conquer` rule. The MR service divides a job in to parallel parts which process data in sets in parallel. The job is executed in 2 phases, Mapper which maps set of data to smaller execution units of the job. After all the smaller execution units processing is done, then comes the Reducing Phase which aggregates the data from all the execution units. In the early days, MR was used as an execution engine which does data processing in the cluster. Now a days, YARN is being used for scheduling and executing data processing jobs in a hadoop cluster.

---

Let's talk about YARN. YARN stands for Yet-Another-Resource-Negotiator. Its a resource management and job scheduling service for Hadoop.
YARN uses container to isolate different smaller units of a Job submitted in a YARN. YARN service has many internal components which takes care of various things ranging from Resource calculation, managing and executing jobs in containers, maintaining history of all the jobs that are being executed in a cluster. The main service of YARN is resource manager.

Resource Manager is the heart of YARN service which handles the resource allocation and scheduling of Applications.
