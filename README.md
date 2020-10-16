# DU-Industry-HUD
A simple HUD for monitoring and managing industry in Dual Universe
 
### Demo Video

[![Demo Video](https://img.youtube.com/vi/T-t3QEe9SK4/0.jpg)](https://www.youtube.com/watch?v=T-t3QEe9SK4)

### Support or donation

if you like it, [<img src="https://github.com/Jericho1060/DU-Industry-HUD/blob/main/ressources/images/ko-fi.png?raw=true" width="150">](https://ko-fi.com/jericho1060)

# Installation

### Introduction

This HUD is using two différent programs :

- Master Program : the one that is displaying the HUD on the user screen
- Data Collection Program : the one that gather informations from the industry

It can permit to monitor a maximum of **1539** Industry machines.

For the both programs, you do not have to rename any slot, the script will detect all the linked elements automatically.

### Installation

#### Data Collection Program

Simply copy the json configuration from the Data Collection Program directory and paste it on a programming board in game.

This programming board must be connected to a databank.

A receiver is used to switch on the board for data update.

This is not requiring a slot but the link must be set from the reciver to the board. (You can add a relay if you need to enable several board at a time).

Set a default channel on the receiver. (you will have to set it on the Master program after)

Connect the board to the machines you want to monitor. No changes needed on that script.

See Mounting Scheme below for more details.


#### Master Program

Simply copy the json configuration from the Master Program directory and paste it on a programming board in game.

This programming board must be linked to the core.

This programming board must be linked to an emitter and to all the databanks used for Data Collection part.

**Modification required :**

- In the LUA Parameters (right clic on the board > advanced > Edit lua parameters) you must set, for each machine type the channel configured on the receiver. You can use the same channel on several types if you do not have one receiver for each type.
- Still in LUA Parameters : You must set the `coreSize` Parameters, by default set to M, you can set it to XS, S, M or L depending on your core Size, this is required to display the mark on the selected machine, otherwise, it will be displayed somewhere else.

Each channel is used to refresh data from the selected machine type on the HUD only.

If you see a machine type you do not have on your construct, just skip it, it will not be used.

#### Mounting Scheme

![Mounting Scheme](https://github.com/Jericho1060/DU-Industry-HUD/blob/main/ressources/images/DU_Industry_HUD_Mounting_2.jpg?raw=true)

#### Options

By editing lua parameters on the Master Program, you can customize some options

- refreshSpeed : the refresh tick time in seconds (set to 1 by default)
- elementsByPage : How many elements are displayed on each page on the HUD (set to 20 by default)
- dateFormat : The format of the date and time displayed on the HUD (set by defaut to "en", "fr" is possible, more options will come later)
- summertime : if your contry is using summer time, enable that option (not enabled by default)
