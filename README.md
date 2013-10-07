This guide walks you through using Gradle to build a simple Java project.

What you'll build
-----------------

You'll create a simple app and then build it using Gradle.


What you'll need
----------------

 - About 15 minutes
 - A favorite text editor or IDE
 - [JDK 6][jdk] or later

[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index.html

How to complete this guide
--------------------------

Like all Spring's [Getting Started guides](/guides/gs), you can start from scratch and complete each step, or you can bypass basic setup steps that are already familiar to you. Either way, you end up with working code.

To **start from scratch**, move on to [Set up the project](#scratch).

To **skip the basics**, do the following:

 - [Download][zip] and unzip the source repository for this guide, or clone it using [Git][u-git]:
`git clone https://github.com/spring-guides/gs-gradle.git`
 - cd into `gs-gradle/initial`.
 - Jump ahead to [Install Gradle](#initial).

**When you're finished**, you can check your results against the code in `gs-gradle/complete`.
[zip]: https://github.com/spring-guides/gs-gradle/archive/master.zip
[u-git]: /understanding/Git


<a name="scratch"></a>
Set up the project
------------------

First you set up a Java project for Gradle to build. To keep the focus on Gradle, make the project as simple as possible for now.

### Create the directory structure

In a project directory of your choosing, create the following subdirectory structure; for example, with `mkdir -p src/main/java/hello` on *nix systems:

    └── src
        └── main
            └── java
                └── hello

### Create Java classes

Within the `src/main/java/hello` directory, you can create any Java classes you want. For simplicity's sake and for consistency with the rest of this guide, Spring recommends that you create two classes: `HelloWorld.java` and `Greeter.java`.

`src/main/java/hello/HelloWorld.java`
```java
package hello;

public class HelloWorld {
  public static void main(String[] args) {
    Greeter greeter = new Greeter();
    System.out.println(greeter.sayHello());
  }
}
```

`src/main/java/hello/Greeter.java`
```java
package hello;

public class Greeter {
  public String sayHello() {
    return "Hello world!";
  }
}
```


<a name="initial"></a>
Install Gradle
--------------

Now that you have a project that you can build with Gradle, you can install Gradle.

Gradle is downloadable as a zip file at http://www.gradle.org/downloads. Only the binaries are required, so look for the link to gradle-_version_-bin.zip. (You can also choose gradle-_version_-all.zip to get the sources and documentation as well as the binaries.)

Unzip the file to your computer, and add the bin folder to your path.

To test the Gradle installation, run Gradle from the command-line:

```sh
$ gradle
```

If all goes well, you see a welcome message:

```sh
:help

Welcome to Gradle 1.8.

To run a build, run gradle <task> ...

To see a list of available tasks, run gradle tasks

To see a list of command-line options, run gradle --help

BUILD SUCCESSFUL

Total time: 2.675 secs
```

You now have Gradle installed.


Find out what Gradle can do
---------------------------
Now that Gradle is installed, see what it can do. Before you even create a build.gradle file for the project, you can ask it what tasks are available:

```sh
$ gradle tasks
```

You should see a list of available tasks. Assuming you run Gradle in a folder that doesn't already have a _build.gradle_ file, you'll see some very elementary tasks such as this:

```sh
:tasks

------------------------------------------------------------
All tasks runnable from root project
------------------------------------------------------------

Build Setup tasks
-----------------
setupBuild - Initializes a new Gradle build. [incubating]
wrapper - Generates Gradle wrapper files. [incubating]

Help tasks
----------
dependencies - Displays all dependencies declared in root project 'gs-gradle'.
dependencyInsight - Displays the insight into a specific dependency in root project 'gs-gradle'.
help - Displays a help message
projects - Displays the sub-projects of root project 'gs-gradle'.
properties - Displays the properties of root project 'gs-gradle'.
tasks - Displays the tasks runnable from root project 'gs-gradle'.

To see all tasks and more detail, run with --all.

BUILD SUCCESSFUL

Total time: 3.077 secs
```

Even though these tasks are available, they don't offer much value without a project build configuration. As you flesh out the build.gradle file, some tasks will be more useful. The list of tasks will grow as you add plugins to build.gradle, so  you'll occasionally want to run **tasks** again to see what tasks are available.

Speaking of adding plugins, next you add a plugin that enables basic Java build functionality.


Build Java code
---------------
Starting simple, create a very basic build.gradle file that has only one line in it:

```groovy
apply plugin: 'java'
```

This single line in the build configuration brings a significant amount of power. Run **gradle tasks** again, and you see new tasks added to the list, including tasks for building the project, creating JavaDoc, and running tests.

You'll use the **gradle build** task frequently. This task compiles, tests, and assembles the code into a JAR file. You can run it like this:

```sh
$ gradle build
```

After a few seconds, "BUILD SUCCESSFUL" indicates that the build has completed. 

To see the results of the build effort, take a look in the _build_ folder. Therein you'll find several directories, including these three notable folders:

* _classes_. The project's compiled .class files.
* _reports_. Reports produced by the build (such as test reports).
* _libs_. Assembled project libraries (usually JAR and/or WAR files).

The classes folder has .class files that are generated from compiling the Java code. Specifically, you should find HelloWorld.class and Greeter.class.

At this point, the project doesn't have any library dependencies, so there's nothing in the *dependency_cache* folder.

The reports folder should contain a report of running unit tests on the project. Because the project doesn't yet have any unit tests, that report will be uninteresting.

The libs folder should contain a JAR file that is named after the project's folder. If you cloned the project from GitHub, then the JAR file is likely named initial.jar. That's probably not what you'd want it named, though.


Declare dependencies
--------------------

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


Build your project with Gradle Wrapper
--------------------------------------

The Gradle Wrapper is the preferred way of starting a Gradle build. It consists of a batch script for Windows support and a shell script for support on OS X and Linux. These scripts allow you to run a Gradle build without requiring that Gradle be installed on your system. You can install the wrapper into your project by adding the following lines to the build.gradle:

```groovy
task wrapper(type: Wrapper) {
    gradleVersion = '1.8'
}
```

Run the following command to download and initialize the wrapper scripts:

```sh
$ gradle wrapper
```

After this task completes, you will notice a few new files. The two scripts are in the root of the folder, while the wrapper jar and properties files have been added to a new `gradle/wrapper` folder.

    └── initial
        └── gradlew
        └── gradlew.bat
        └── gradle
            └── wrapper
                └── gradle-wrapper.jar
                └── gradle-wrapper.properties

The Gradle Wrapper is now available for building your project. It can be used in the exact same way as an installed version of Gradle. Run the wrapper script to perform the build task, just like you did previously:

```sh
$ ./gradlew build
```

The first time you run the wrapper for a specified version of Gradle, it downloads and caches the Gradle binaries for that version. The Gradle Wrapper files are designed to be committed to source control so that anyone can build the project without having to first install and configure a specific version of Gradle.

Here is the completed `build.gradle` file:

`build.gradle`
```gradle
apply plugin: 'java'
apply plugin: 'eclipse'

repositories { mavenCentral() }
dependencies {
    compile "joda-time:joda-time:2.2"
}

task wrapper(type: Wrapper) {
    gradleVersion = '1.8'
}
```


Summary
-------

Congratulations! You have now created a simple yet effective Gradle build file for building Java projects.
