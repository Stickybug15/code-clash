# Code Conquest - The Adventure Game

Read [Document](./docs/README.md) for game documents

Read [Github Desktop](./docs/guide/git.md) for how to setup github desktop.

Read [Study](./docs/guide/study.md) for study references.

Read [Assets](./docs/assets/assets.md) for the list of interesting assets.

## How to setup the game?

Follow the steps and instruction below to properly setup the game development.

**You can't run the game on your Phone, PC is required.**

You need to install `git` to setup the Godot Project.

Assuming you already have VSCode installed, so we will be installing `git`.

Go to [Git Website](https://git-scm.com/downloads), look for **Downloads**, and click **Windows**, find **Git for Windows/x64 Setup**, click it and the *installer* will be download automatically, wait for it until it finished downloading.

After the installer was downloaded, run it:

- Just click **Next** until you see "Choose the Default Editor used by Git", there should be choices to what Editor you will use:

 - Choose "Use Visual Studio Code as Git's default editor"

 - After that, just click **Next** until it installs, and click **Finish**.

Now that the Git is installed, we just need to setup godot project.

press "Windows" Key on your keyboard, and search for "Git Bash" and run it.

Enter this command:

CAUTION: entering these commands will use a lot of internet data, because it downloads godot and compilers in order to setup the project, if you're sure you have a lot of data, then you can proceed.

```bash
cd ~/Desktop/
git clone --depth 1 https://github.com/NexushasTaken/code-clash code-clash
cd code-clash
./init.sh
```

> Running these commands might take a while

After you run the commands, you can run this command to open godot:

```bash
./godot.sh &
```

You can close Git Bash window, and start coding!

## How to open godot, again...

Let's say you closed the Godot Engine and Git Bash.

Then open "Git Bash" and pressing "Windows" Key on your keyboard and search for "Git Bash".

Enter these commands:

```bash
cd ~/Desktop/code-clash
./godot.sh
```

