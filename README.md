Another Snips docker
===========================

Credit where credit is due, i got a lot of inspiration from https://github.com/dYalib/snips-docker. The script `start.sh` is a copy from that repo, with some alterations. I chose to create my own version because i wanted to have audio on my main unit as well as having satellites.

I have added Pulse audio, snips-watch and only support for external MQTT broker.

To get started copy `snips.toml` into `local_files` and edit the config to fit your setup. Then build and run container.



Environment variables
-------------------------

To use Pulse audio the following env vars are needed:
- `XDG_RUNTIME_DIR` - Should be set by default if you have Pulse audio installed.
- `AUDIO_GROUP`     - Set to `getent group audio | cut -d: -f3`, group id for access to the audio.

**Note** while running docker-compose with sudo and env vars set with other user the vars wont be passed to the docker process. Run docker-compose with `sudo -E docker-compose up -d` to pass vars to the docker process.



Docker-compose
-------------------------

Example of an entry in docker-compose.yml.

```
snips:
  container_name: snips
  build:
      context: <path-to-this-repository>
      args:
          - AUDIO_GROUP=${AUDIO_GROUP}
  networks: # This is for telling Docker which network bridge to use. Can be removed if no need for specific network
    <name-of-networ-to-use>:
      ipv4_address: <ip-adress-the-container-should-have>
  volumes:
      - <path-to-assistant-folder>:/usr/share/snips/assistant
      - <path-to-snips.toml>:/etc/snips.toml
      - ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native
      - ~/.config/pulse/cookie:/root/.config/pulse/cookie
      - /etc/localtime:/etc/localtime:ro
  environment:
      - PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native
  restart: always
```



Utility scripts
------------------------

- `edit_skills.py` can be used to alter code and End-user parameters in skills. For example it can be used to insert values to End-use parameters in the config or change hard coded ip-adresses to MQTT brokers. Copy `skills_to_edit.py` into `local_files` and edit variables to fit your need.

- `deploy_assistant.sh` can be used to unzip and move an assistant to the correct folder. It will also set `sudo chmod o+w assistant` on the directory, Snips won't read the `assistant.json` file otherwise (there probably is a better solution to this, user rights?).



TO-DO
---------------------------

- Try with Satellites.
- Support local MQTT broker, see dYalib's implementation.



Misc.
-----------------------

Great guides on MQTT:

- [General guide](http://www.steves-internet-guide.com/mqtt/)
- [Create multiple users](http://www.steves-internet-guide.com/mqtt-username-password-example/)
- [Control access for topics](http://www.steves-internet-guide.com/topic-restriction-mosquitto-configuration/)



Personal notes
-------------------

- Add commands for goodnight, dinner (tv/reciever on), movie and party.
- Do i need to fix so HA docker wait for mosquitto connection on startup?
