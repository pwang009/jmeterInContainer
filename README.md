[![Docker Build](https://img.shields.io/docker/automated/justb4/jmeter.svg)](https://hub.docker.com/r/justb4/jmeter)
[![Patreon](https://img.shields.io/badge/patreon-donate-yellow.svg)](https://patreon.com/justb4)

# Apache Jmeter v5.4 Running In A Docker Container

## Credits 
This public github repo is inspired by https://github.com/justb4/docker-jmeter.git.  

## Major Changes Made

1. In run.sh, add user and group with -u switch.  So the last line of the file becomes  
   
   docker run --rm --name ${NAME} -u 1000:1000 -i -v ${PWD}:${PWD} -w ${PWD} ${IMAGE} $@  
      
   If the -u switch is left out, files created in the Report folder is going to be owned by root, which 
   causes an issue on deletion to the subsequent runs.  This changes has been validated in the ubuntu 20.04
   in WSL 2 on Windows 10 machine
2. Another test example added in the test/lbh folder to test restful api
   The use case is that assuming you have restful api in 2 different environments, prod and qa.  You want to run perf
   test against both environments.  To accomplish that, follow the steps below  
   a.  Define your api endpoint in the environment param.Data.csv file, e.g. qa/param.Data.csv     
   b.  export parameter file as environment variable, e.g. export PARAM_FILE=prod/param.Data.csv  
   c.  run ./lbh.test.sh script in the project root directory  

## Following documentation is from original repo

## Image on Docker Hub

Docker image for [Apache JMeter](http://jmeter.apache.org).
This Docker image can be run as the ``jmeter`` command. 
Find Images of this repo on [Docker Hub](https://hub.docker.com/r/justb4/jmeter).

## Building

With the script [build.sh](build.sh) the Docker image can be build
from the [Dockerfile](Dockerfile) but this is not really necessary as
you may use your own ``docker build`` commandline. Or better: use one
of the pre-built Images from [Docker Hub](https://hub.docker.com/r/justb4/jmeter).

See end of this doc for more detailed build/run/test instructions (thanks to @wilsonmar!)

### Build Options

Build arguments (see [build.sh](build.sh)) with default values if not passed to build:

- **JMETER_VERSION** - JMeter version, default ``5.4``. Use as env variable to build with another version: `export JMETER_VERSION=5.4`
- **IMAGE_TIMEZONE** - timezone of Docker image, default ``"Europe/Amsterdam"``. Use as env variable to build with another timezone: `export IMAGE_TIMEZONE="Europe/Berlin"`

## Running

The Docker image will accept the same parameters as ``jmeter`` itself, assuming
you run JMeter non-GUI with ``-n``.

There is a shorthand [run.sh](run.sh) command.
See [test.sh](test.sh) for an example of how to call [run.sh](run.sh).

## User Defined Variables

This is a standard facility of JMeter: settings in a JMX test script
may be defined symbolically and substituted at runtime via the commandline.
These are called JMeter User Defined Variables or UDVs.

See [test.sh](test.sh) and the [trivial test plan](tests/trivial/test-plan.jmx) for an example of UDVs passed to the Docker 
image via [run.sh](run.sh).

See also: http://blog.novatec-gmbh.de/how-to-pass-command-line-properties-to-a-jmeter-testplan/

## Installing JMeter plugins

To run the container with custom JMeter plugins installed you need to mount a volume /plugins with the .jar files. For example: 
```sh 
sudo docker run --name ${NAME} -i -v ${LOCAL_PLUGINS_FOLDER}:/plugins -v ${LOCAL_JMX_WORK_DIR}:${CONTAINER_JMX_WORK_DIR} -w ${PWD} ${IMAGE} $@
```

The ${LOCAL_PLUGINS_FOLDER} must have only .jar files. Folders and another file extensions will not be considered.

## Do it for real: detailed build/run/test

Contribution by @wilsonmar

1. In a Terminal/Command session, install Git, navigate/make a folder, then:

   ```
   git clone https://github.com/justb4/docker-jmeter.git
   cd docker-jmeter
   ```

1. Run the Build script to download dependencies, including the docker CLI:

   ```
   ./build.sh
   ```

   If you view this file, the <strong>docker build</strong> command within the script is for a specific version of JMeter and implements the <strong>Dockerfile</strong> in the same folder. 
   
   If you view the Dockerfile, notice the `JMETER_VERSION` specified is the same as the one in the build.sh script. The FROM keyword specifies the Alpine operating system, which is very small (less of an attack surface). Also, no JMeter plug-ins are used.
   
   At the bottom of the Dockerfile is the <strong>entrypoint.sh</strong> file. If you view it, that's where JVM memory settings are specified for <strong>jmeter</strong> before it is invoked. PROTIP: Such settings need to be adjusted for tests of more complexity.

   The last line in the response should be:
   
   <tt>Successfully tagged justb4/jmeter:5.3</tt>

1. Run the test script:

   ```
   ./test.sh
   ```

   If you view the script, note it invokes the <strong>run.sh</strong> script file stored at the repo's root. View that file to see that it specifies docker image commands.
   
   File and folder names specified in the test.sh script is reflected in the last line in the response for its run:

   <pre>
   ==== HTML Test Report ====
   See HTML test report in tests/trivial/report/index.html
   </pre>

   *Alternative exec by Makefile:*

   Like the bash script, it is possible to run the tests through a **Makefile** simply with the `make` command or by sending parameters as follows:

   ```sh
   TARGET_HOST="www.map5.nl" \
   TARGET_PORT="80" \
   THREADS=10 \
   TEST=trivial \
   make
   ```   

1. Switch to your machine's Folder program and navigate to the folder containing files which replaces files cloned in from GitHub:
   
   ```
   cd tests/trivial
   ```
   
   The files are:
   
   * jmeter.log
   * reports folder (see below)
   * test-plan.jmx containing the JMeter test plan.
   * test-plan.jtl containing statistics from the run displayed by the index.html file.
   
   
1. Navigate into the <strong>report</strong> folder and open the <strong>index.html</strong> file to pop up a browser window displaying the run report. On a Mac Terminal:
   
   ```
   cd report
   open index.html
   ```

   Here is a sample report:

   ![docker-jmeter-report](https://user-images.githubusercontent.com/300046/54093523-1a1c3d80-436f-11e9-8930-750e9b736084.png)


## Specifics

The Docker image built from the 
[Dockerfile](Dockerfile) inherits from the [Alpine Linux](https://www.alpinelinux.org) distribution:

> "Alpine Linux is built around musl libc and busybox. This makes it smaller 
> and more resource efficient than traditional GNU/Linux distributions. 
> A container requires no more than 8 MB and a minimal installation to disk 
> requires around 130 MB of storage. 
> Not only do you get a fully-fledged Linux environment but a large selection of packages from the repository."

See https://hub.docker.com/_/alpine/ for Alpine Docker images.

The Docker image will install (via Alpine ``apk``) several required packages most specificly
the ``OpenJDK Java JRE``.  JMeter is installed by simply downloading/unpacking a ``.tgz`` archive
from http://mirror.serversupportforum.de/apache/jmeter/binaries within the Docker image.

A generic [entrypoint.sh](entrypoint.sh) is copied into the Docker image and
will be the script that is run when the Docker container is run. The
[entrypoint.sh](entrypoint.sh) simply calls ``jmeter`` passing all argumets provided
to the Docker container, see [run.sh](run.sh) script:

```
sudo docker run --name ${NAME} -i -v ${WORK_DIR}:${WORK_DIR} -w ${WORK_DIR} ${IMAGE} $@
```

## Credits

Thanks to https://github.com/hauptmedia/docker-jmeter
and https://github.com/hhcordero/docker-jmeter-server for providing
the Dockerfiles that inspired me.   @wilsonmar for contributing detailed instructions. Others
that tested/reported after version updates.


## Credits 2
This public github repo is inspired by https://github.com/justb4/docker-jmeter.git 
