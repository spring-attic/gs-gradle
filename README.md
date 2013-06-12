Building Java Projects with Gradle
==================================
This Getting Started guide will walk you through a few basic pieces of setting up and using a Gradle build.

To help you get started, we've provided an initial project structure as well as the completed project for you in GitHub:

```sh
$ git clone https://github.com/springframework-meta/gs-gradle.git
```

In the `start` folder, you'll find a bare project, ready for you to copy-n-paste code snippets from this document. In the `complete` folder, you'll find the complete project code. 

In both cases, you'll find a simple Java project that we'll build. Our focus will be on the _build.gradle_ and _gradle.settings_ files. The Java files are only there as source for our build efforts.

We'll start by installing Gradle and then start filling in the _build.gradle_ file. If you already have Gradle installed, then you can jump to the [fun part](#finding-out-what-gradle-can-do).

Installing Gradle
-----------------
Gradle is downloadable as a zip file at http://www.gradle.org/downloads. Only the binaries are required, so look for the link to gradle-_{version}_-bin.zip. (If you want, you can also choose gradle-_{version}_-all.zip to get the sources and documentation as well as the binaries.)

Once you have downloaded the zip file, unzip it to your computer. Then add the _bin_ folder to your path.

To test the Gradle installation, run gradle from the command-line:

```sh
$ gradle
```

If all goes well, you should see a welcome message that looks something like the following:

```sh
:help

Welcome to Gradle 1.5.

To run a build, run gradle <task> ...

To see a list of available tasks, run gradle tasks

To see a list of command-line options, run gradle --help

BUILD SUCCESSFUL

Total time: 1.857 secs 
```

Congratulations! You now have Gradle installed.

Finding Out What Gradle Can Do
------------------------------
Now that Gradle is installed, let's kick the tires on it and see what it can do. Before we even create a _build.gradle_ file for the project, there's already something we can do with Gradle: Ask it what tasks are available. To do that, issue the following on the command line:

```sh
$ gradle tasks
```

You should see a list of tasks that are available in Gradle. Assuming you run Gradle in a folder where there's not already a _build.gradle_ file, you'll see some very elementary tasks such as this:

```sh
:tasks

------------------------------------------------------------
All tasks runnable from root project
------------------------------------------------------------

Help tasks
----------
dependencies - Displays all dependencies declared in root project 'Downloads'.
dependencyInsight - Displays the insight into a specific dependency in root project 'Downloads'.
help - Displays a help message
projects - Displays the sub-projects of root project 'Downloads'.
properties - Displays the properties of root project 'Downloads'.
tasks - Displays the tasks runnable from root project 'Downloads' (some of the displayed tasks may belong to subprojects).
```

Even though these tasks are available, they don't offer much value without a project build configuration. But as we flesh out our build.gradle file, some of these tasks will be more useful. And, the list of tasks will grow as we add plugins to our build.gradle file, so  you'll occasionally want to run the "tasks" task again to see what tasks are available.

Speaking of adding plugins, let's add a plugin that enables basic Java build functionality.

Building Java Code
------------------
Starting simple, let's create a very basic build.gradle file that has only one line in it:

```groovy
apply plugin: 'java'
```

This single line in our build configuration brings a significant amount of power. If you the "tasks" task again, you'll see some new tasks added to the list, including tasks for building the project, creating JavaDoc, and running tests.

Let's try one of those tasks. The "build" task is probably one of the tasks you'll use most often with Gradle. This task compiles, tests, and assembles the code into a JAR file. You can run it like this:

```sh
$ gradle build
```

After a few seconds, you should see the words "BUILD SUCCESSFUL", indicating that the build has completed. 

To see the results of the build effort, take a look in the _build_ folder. Therein you'll find several directories, including these three notable folders:

* _classes_ - The project's compiled .class files
* _reports_ - Any reports produced by the build (such as test reports)
* _libs_ - The assembled project libraries (usually JAR and/or WAR files)

In the _classes_ folder, you'll find the .class files resulting from compiling our Java code. Specifically, you should find _HelloWorld.class_ and _Greeter.class_.

At this point, our project doesn't have any library dependencies, so there's nothing in the *dependency_cache* folder.

The _reports_ folder should contain a report of running unit tests on our project. Since our project doesn't yet have any unit tests, that report will be uninteresting.

The _libs_ folder should contain a JAR file that is named after the project's folder. If you cloned the project from GitHub, then the JAR file is likely named _start.jar_. That's probably not what you'd want it named, though.

Declaring Dependencies
----------------------
Our simple Hello World sample is completely self-contained and does not depend on any additional libraries. Most application, however, depend on external libraries to handle common and/or complex functionality.

For example, suppose that in addition to saying "Hello World!", we wanted our application to print the current date and time. While we could use the date and time facilities in the native Java libraries, let's make things more interesting by using the Joda Time libraries.

First, let's change HelloWorld.java to look like this:

```java
package hello;

import org.joda.time.LocalTime;

public class HelloWorld {
  public static void main(String[] args) {
    LocalTime currentTime = new LocalTime();
    System.out.println("The current local time is: " + currentTime);

    Greeter greeter = new Greeter();
    System.out.println(greeter.sayHello());
  }
}
```

Here we're using Joda Time's `LocalTime` class to get and print the current time. 

If we were to run `gradle build` to build our project now, the build would fail because we've not declared Joda Time as a compile dependency in our build. Let's fix that by adding the following lines to _build.gradle_:

```groovy
repositories { mavenCentral() }
dependencies {
  compile "joda-time:joda-time:2.2"
}
```

The first line here indicates that our build should resolve its dependencies from the Maven Central repository. Gradle leans heavily on many conventions and facilities established by the Maven build tool, including the option of using Maven Central as a source of library dependencies.

Within the `dependencies` block, we've declared a single dependency for Joda Time. Specifically, we're asking for (reading right to left) version 2.2 of the _joda-time_ library, in the _joda-time_ group. 

Another thing to note about this dependency is that it is a `compile` dependency, indicating that it should be available during compile-time (and if we were building a WAR file, included in the _/WEB-INF/libs_ folder of the WAR). Other notable types of dependencies include:

* `providedCompile` - Dependencies that are required for compiling the project code, but that will be provided at runtime by a container running the code (e.g., the Java Servlet API).
* `testCompile` - Dependencies used for compiling and running tests, but not required for building or running the project's runtime code.

Now if you run `gradle build`, Gradle should resolve the Joda Time dependency from the Maven Central repository and the build will be successful.

Next Steps
==========
Congratulations! You have now created a very simple, yet effective Gradle build file for building Java projects.

There's much more to building projects with Gradle. For continued exploration of Gradle, you may want to have a look at the following Getting Started guides:

* Building web applications with Gradle
* Setting Gradle properties
* Using the Gradle wrapper

And for an alternate approach to building projects, you may want to look at [Building Java Projects with Maven](https://github.com/springframework-meta/gs-maven/blob/master/README.md).
