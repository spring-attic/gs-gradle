# Getting Started: Building Java Projects with Gradle

What you'll build
-----------------

This guide walks you through using Gradle to build a simple Java project. 

What you'll need
----------------

 - About 15 minutes
 - A favorite text editor or IDE
 - [JDK 6][jdk] or later

[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index.html

## {!include#how-to-complete-this-guide}

<a name="scratch"></a>
Set up the project
------------------

First you set up a Java project for Gradle to build. To keep the focus on Gradle, make the project as simple as possible for now.

{!include#create-directory-structure-hello}

### Create Java classes

Within the `src/main/java/hello` directory, you can create any Java classes you want. For simplicity's sake and for consistency with the rest of this guide, Spring recommends that you create two classes: `HelloWorld.java` and `Greeter.java`.

    {!include:complete/src/main/java/hello/HelloWorld.java}

    {!include:complete/src/main/java/hello/Greeter.java}


<a name="initial"></a>
### Install Gradle

Now that you have a project that you can build with Gradle, you can install Gradle.

Gradle is downloadable as a zip file at http://www.gradle.org/downloads. Only the binaries are required, so look for the link to gradle-_version_-bin.zip. (You can also choose gradle-_version_-all.zip to get the sources and documentation as well as the binaries.)

After you download the zip file, unzip it to your computer. Then add the bin folder to your path.

To test the Gradle installation, run Gradle from the command-line:

```sh
$ gradle
```

If all goes well, you see a welcome message like the following:

```sh
:help

Welcome to Gradle 1.5.

To run a build, run gradle <task> ...

To see a list of available tasks, run gradle tasks

To see a list of command-line options, run gradle --help

BUILD SUCCESSFUL

Total time: 1.857 secs 
```

You now have Gradle installed.

Find out what Gradle can do
------------------------------
Now that Gradle is installed, kick the tires on it and see what it can do. Before you even create a build.gradle file for the project, you can ask it what tasks are available:

```sh
$ gradle tasks
```

You should see a list of available tasks. Assuming you run Gradle in a folder that doesn't already have a _build.gradle_ file, you'll see some very elementary tasks such as this:

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

Even though these tasks are available, they don't offer much value without a project build configuration. As you flesh out the build.gradle file, some tasks will be more useful. The list of tasks will grow as you add plugins to the build.gradle file, so  you'll occasionally want to run **tasks** again to see what tasks are available.

Speaking of adding plugins, next you add a plugin that enables basic Java build functionality.

Build Java code
------------------
Starting simple, create a very basic build.gradle file that has only one line in it:

```groovy
apply plugin: 'java'
```

This single line in the build configuration brings a significant amount of power. Run **tasks** again, and you see new tasks added to the list, including tasks for building the project, creating JavaDoc, and running tests.

The **build** task is probably one of the tasks you'll use most often with Gradle. This task compiles, tests, and assembles the code into a JAR file. You can run it like this:

```sh
$ gradle build
```

After a few seconds, "BUILD SUCCESSFUL" indicates that the build has completed. 

To see the results of the build effort, take a look in the _build_ folder. Therein you'll find several directories, including these three notable folders:

* _classes_. The project's compiled .class files.
* _reports_. Reports produced by the build (such as test reports).
* _libs_. Assembled project libraries (usually JAR and/or WAR files).

In the classes folder, you'll find the .class files resulting from compiling the Java code. Specifically, you should find HelloWorld.class and Greeter.class.

At this point, the project doesn't have any library dependencies, so there's nothing in the *dependency_cache* folder.

The reports folder should contain a report of running unit tests on the project. Because the project doesn't yet have any unit tests, that report will be uninteresting.

The libs folder should contain a JAR file that is named after the project's folder. If you cloned the project from GitHub, then the JAR file is likely named start.jar. That's probably not what you'd want it named, though.

Declare dependencies
----------------------

The simple Hello World sample is completely self-contained and does not depend on any additional libraries. Most applications, however, depend on external libraries to handle common and/or complex functionality.

For example, suppose that in addition to saying "Hello World!", you want the application to print the current date and time. You could use the date and time facilities in the native Java libraries, but you can make things more interesting by using the Joda Time libraries.

First, change HelloWorld.java to look like this:

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

Here `HelloWorld` uses Joda Time's `LocalTime` class to get and print the current time. 

If you ran `gradle build` to build the project now, the build would fail because you have not declared Joda Time as a compile dependency in the build. You can fix that by adding the following lines to build.gradle:

```groovy
repositories { mavenCentral() }
dependencies {
  compile "joda-time:joda-time:2.2"
}
```

The first line here indicates that the build should resolve its dependencies from the Maven Central repository. Gradle leans heavily on many conventions and facilities established by the Maven build tool, including the option of using Maven Central as a source of library dependencies.

Within the `dependencies` block, you declare a single dependency for Joda Time. Specifically, you're asking for (reading right to left) version 2.2 of the joda-time library, in the joda-time group. 

Another thing to note about this dependency is that it is a `compile` dependency, indicating that it should be available during compile-time (and if you were building a WAR file, included in the /WEB-INF/libs folder of the WAR). Other notable types of dependencies include:

* `providedCompile`. Required dependencies for compiling the project code, but that will be provided at runtime by a container running the code (for example, the Java Servlet API).
* `testCompile`. Dependencies used for compiling and running tests, but not required for building or running the project's runtime code.

Now if you run `gradle build`, Gradle should resolve the Joda Time dependency from the Maven Central repository and the build will succeed.

Here's the completed `build.gradle` file:

    {!include:complete/build.gradle}

Summary
=======
Congratulations! You have now created a simple yet effective Gradle build file for building Java projects.
