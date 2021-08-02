## Tic Tac Toe with IRIS
This is a template for InterSystems ObjectScript Github repository.
The template goes also with a few files which let you immedietly compile your ObjecScript files in InterSystems IRIS Community Edition in a docker container

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation

Open terminal and clone/git pull the repo into any local directory as shown below:

```
$ git clone https://github.com/henryhamon/tic-tac-toe
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

Run the IRIS container with your project:

```
$ docker-compose up -d
```

## How to Test

Open IRIS terminal:

```
$ docker-compose exec iris iris session iris
USER>Do ##class(dc.Game.TicTacToe).Start()
```


## Author ##

 * Henry "HammZ" Hamon Pereira [github](https://github.com/henryhamon)
